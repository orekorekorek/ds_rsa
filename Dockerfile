FROM ruby:3.0.3-slim

WORKDIR /app

RUN apt update && \
  apt install -y gcc make

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . /app

CMD ["ruby", "main.rb"]
