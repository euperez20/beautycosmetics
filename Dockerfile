# Use the official Ruby image as the base image
FROM ruby:3.1.2

# Set the working directory in the container
WORKDIR /app

# Install bundler and dependencies
RUN gem install bundler:2.4.14
COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN apt-get update && apt-get install -y nodejs


# Copy the rest of the application code into the container
COPY . .

# Set the default command to run the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
