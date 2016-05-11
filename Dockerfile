FROM ruby:2.2.5-onbuild
RUN gem install json aws-s3 colorize openssl
RUN ruby /usr/src/app/collector.rb
