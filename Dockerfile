FROM ruby:2.2.5-onbuild
RUN ruby /usr/src/app/collector.rb
