# Base image
FROM ruby:2.2.5

ENV HOME /home/rails/webapp

# Install dependencies
RUN apt-get update -qq

WORKDIR $HOME

# Install gems
ADD Gemfile* $HOME/
RUN gem install bundle
RUN bundle install

# Add the app code
ADD . $HOME

# Default command
CMD ["ruby", "collector.rb"]
