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
    #get all credentials from the credentails file
    credentials = eval(File.read("credentials.txt"))

    puts "--- Starting Data Collection ---".yellow
	  #get current data from ryans nest
	  uri = URI.parse(credentials["nest_firebase_api"])
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true
	  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	  response = http.get(uri.request_uri)
	  ryans_thermostat = JSON.parse(response.body)
	  puts "[Success] - ".green + "Pulled down API data from Ryans nest at: " + Time.now.utc.iso8601

	  #get current data from the closest weather station to ryans house
	  uri = URI.parse(credentials["weather_underground_api"])
	  http = Net::HTTP.new(uri.host, uri.port)
	  response = http.get(uri.request_uri)
	  ryans_local_weather = JSON.parse(response.body)
	  puts "[Success] - ".green + "Pulled down API data from Ryans local weather station at: " + Time.now.utc.iso8601

	  #create object data
	  content_type = "application/json"

	  #make a hash of both the nest and weather station data
	  weather_hash = {:thermostat => ryans_thermostat, :weather_station => ryans_local_weather}
	  object_name = "ryan_data_" + Time.now.utc.iso8601

	  #connect to the object store and get the container
	  AWS::S3::Base.establish_connection!(:server => credentials["s3endpoint"], :access_key_id => credentials["s3username"], :secret_access_key => credentials["s3password"])
	  puts "[Success] - ".green + "Created a S3 connection at: " + Time.now.utc.iso8601

	  #save ryans data to the object store
	  S3Object.store(object_name, weather_hash.to_s, credentials["s3bucket"], :content_type => content_type)
	  puts "[Success] - ".green + "Stored the API data in the S3 object store at: " + Time.now.utc.iso8601
	  puts "--- Sleeping until the next data collection ---".yellow
    AWS::S3::Base.disconnect!
    AWS::S3::Service.disconnect!
    AWS::S3::Bucket.disconnect!
    AWS::S3::Service.instance_variable_set(:@buckets, nil)
	  sleep(interval)
  rescue Exception => error
    puts "[Error] - ".red + "#{error}".red
    puts "Ending data collection for this interval. Data may or may not have been uploaded to the object store".red
    puts "--- Sleeping until the next data collection ---".yellow
    sleep(interval)
  end
end
