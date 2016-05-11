require 'openssl'
require 'net/http'
require 'json'
require 'time'
require 'aws/s3'
require 'colorize'
include AWS::S3

loop do
  #set data collection interval in seconds
  interval = 300

  #begin the data collection
  begin
    #hide digest error message
    $stderr = StringIO.new

    #get all credentials from the credentails file
    credentials = eval(File.read("credentials.txt"))

    #log that data collection is starting
    puts "--- Starting Data Collection ---".yellow
    open('collector.log', 'a') do |f|
      f.puts "--- Starting Data Collection ---"
    end

    #get current data from ryans nest
    uri = URI.parse(credentials["nest_firebase_api"])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.get(uri.request_uri)
    thermostat = JSON.parse(response.body)

    #log success
    puts Time.now.utc.iso8601 + " - [Success] - ".green + "Pulled down API data from the Nest Thermostat"
    open('collector.log', 'a') do |f|
      f.puts Time.now.utc.iso8601 + " - [Success] - Pulled down API data from the Nest Thermostat"
    end

    #get current data from the closest weather station to ryans house
    uri = URI.parse(credentials["weather_underground_api"])
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.get(uri.request_uri)
    local_weather = JSON.parse(response.body)

    #log success
    puts Time.now.utc.iso8601 + " - [Success] - ".green + "Pulled down API data from the local weather station"
    open('collector.log', 'a') do |f|
      f.puts Time.now.utc.iso8601 + " - [Success] - Pulled down API data from the local weather station"
    end

    #create object data
    content_type = "application/json"

    #make filenames for both files
    nest_name = credentials["id"] + "_nestAPI_" + Time.now.utc.iso8601
    wunderground_name = credentials["id"] + "_wundergroundAPI_" + Time.now.utc.iso8601

    #connect to the object store and get the container
    AWS::S3::Base.establish_connection!(:server => credentials["s3endpoint"], :access_key_id => credentials["s3username"], :secret_access_key => credentials["s3password"])

    #log success
    puts Time.now.utc.iso8601 + " - [Success] - ".green + "Created a S3 connection"
    open('collector.log', 'a') do |f|
      f.puts Time.now.utc.iso8601 + " - [Success] - Created a S3 connection"
    end

    #save api data to the object store
    S3Object.store(nest_name, thermostat.to_s, credentials["s3bucket"], :content_type => content_type)
    puts Time.now.utc.iso8601 + " - [Success] - ".green + "Stored Nest API data in the S3 object store"
    open('collector.log', 'a') do |f|
      f.puts Time.now.utc.iso8601 + " - [Success] - Stored Nest API data in the S3 object store"
    end

    S3Object.store(wunderground_name, local_weather.to_s, credentials["s3bucket"], :content_type => content_type)
    puts Time.now.utc.iso8601 + " - [Success] - ".green + "Stored Weather Station API data in the S3 object store"
    open('collector.log', 'a') do |f|
      f.puts Time.now.utc.iso8601 + " - [Success] - Stored Weather Station API data in the S3 object store"
    end

    #log complete
    puts "--- Sleeping until the next data collection ---".yellow
    open('collector.log', 'a') do |f|
      f.puts "--- Sleeping until the next data collection ---"
    end

    #write log file to object store and then wipe the local file
    log = File.read("collector.log")
    log_name = "log_" + Time.now.utc.iso8601
    S3Object.store(log_name, log.to_s, credentials["s3bucket"], :content_type => content_type)
    File.truncate('collector.log', 0)

    #close all object storage connections
    AWS::S3::Base.disconnect!
    AWS::S3::Service.disconnect!
    AWS::S3::Bucket.disconnect!
    AWS::S3::Service.instance_variable_set(:@buckets, nil)

    #wait for next interval
    sleep(interval)
  rescue Exception => error
    puts Time.now.utc.iso8601 + " - [Error] - ".red + "#{error}".red
    puts Time.now.utc.iso8601 + " - Ending data collection for this interval. Data may or may not have been uploaded to the object store".red
    puts "--- Sleeping until the next data collection ---".yellow
    open('collector.log', 'a') do |f|
      f.puts Time.now.utc.iso8601 + " - [Error] - ".red + "#{error}"
      f.puts Time.now.utc.iso8601 + " - Ending data collection for this interval. Data may or may not have been uploaded to the object store"
      f.puts "--- Sleeping until the next data collection ---"
    end

    #write log file to object store and then wipe the local file
    log = File.read("collector.log")
    log_name = "log_" + Time.now.utc.iso8601
    #connect to the object store and get the container
    AWS::S3::Base.establish_connection!(:server => credentials["s3endpoint"], :access_key_id => credentials["s3username"], :secret_access_key => credentials["s3password"])
    S3Object.store(log_name, log.to_s, credentials["s3bucket"], :content_type => content_type)
    File.truncate('collector.log', 0)
    sleep(interval)
  end
end
