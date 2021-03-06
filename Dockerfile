# Base image
FROM ruby:2.2.5

ENV HOME /home/rails/webapp

# Install dependencies
RUN apt-get update -qq && apt-get install -y vim

WORKDIR $HOME

# Install gems
ADD Gemfile* $HOME/
RUN gem install bundle
RUN bundle install
RUN gem install aws-s3 json openssl colorize
# Add the app code
ADD . $HOME

# Default command
CMD ["ruby", "collector.rb"]
