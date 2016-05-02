##Overview
This is a simple ruby script that will pull down environmental data from a Nest Thermostat and a local weather station to be used for data analytics projects. The data from both sources is then combined into a JSON file and stored in an object storage repository using the S3 protocol. The script runs on a loop every 5 minutes.

![img1](https://raw.githubusercontent.com/ryn1727/Weather-Collector/master/collector_running.JPG)

##Installation

1. Sign up for a Nest Developer account at https://developers.nest.com/. Create a cloud device and go through the authorization process. Once completed you can use the Firebase API to access your nest thermostat using your authorization token. The API address to access the your Nest Thermostat is: https://firebase-apiserver08-tah01-iad01.dapi.production.nest.com:9553/devices/thermostats?auth=YOURAUTHTOKENHERE 

2. Sign up for a Weather Underground account at https://www.wunderground.com/weather/api/. Go through the authorization process. Once completed you can querey your local weather station using your zip code and API key. The API address to access your local weather station is: http://api.wunderground.com/api/YOURAPIKEYHERE/features/conditions/q/YOURZIPCODEHERE.json

3. Update the credentials file with your Nest, Weather Underground, and S3 object store information.


##Setup
1. XXXXX

2. XXXXX

3. XXXXX


##Licensing
Copyright (c) 2016 Ryan Murphy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
