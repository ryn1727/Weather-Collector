FROM ruby:2.2.5-onbuild
RUN gem install json colorize aws-s3 openssl
CMD ["./collector.rb"]
