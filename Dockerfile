FROM ruby:2.4

RUN gem install bundler
WORKDIR /usr/src/app/
COPY . /usr/src/app
