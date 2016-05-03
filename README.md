##Overview
This is a ruby script/application that will pull down environmental data from a Nest Thermostat and a local weather station every 5 minutes to be used for data analytics projects. The data from both sources is combined into a JSON file and stored in an S3 compatible object storage repository.

![img1](https://raw.githubusercontent.com/ryn1727/Weather-Collector/master/collector_running.JPG)
![img1](https://raw.githubusercontent.com/ryn1727/Weather-Collector/master/collector_running2.JPG)

##Installation Requirements

1. Run's on any platform or operating system that has Ruby 2.2 or higher available.

2. Sign up for a Nest Developer account at https://developers.nest.com/. Create a cloud device and go through the authorization process. Once completed you can use the Firebase API to access your nest thermostat using your authorization token. The API address to access the your Nest Thermostat is: https://firebase-apiserver08-tah01-iad01.dapi.production.nest.com:9553/devices/thermostats?auth=YOURAUTHTOKENHERE 

3. Sign up for a Weather Underground account at https://www.wunderground.com/weather/api/. Go through the authorization process. Once completed you can querey your local weather station using your zip code and API key. The API address to access your local weather station is: http://api.wunderground.com/api/YOURAPIKEYHERE/features/conditions/q/YOURZIPCODEHERE.json

4. Make sure you have your credentials and a bucket ready from a S3 compatible object store.


##Setup
1. Clone the repository to your computer/server. 

2. Install Ruby v2.2 or greater.

3. Make sure the following gems are installed: openssl, json, aws/s3, and colorize: gem install json openssl colorize aws-s3

4. Update the credentials file with your Nest, Weather Underground, and S3 object store information.

5. Run the script: "ruby collector.rb".


##Licensing
Copyright (c) 2016 Ryan Murphy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
