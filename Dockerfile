FROM ruby:2.5-slim
RUN apt-get update -qq && apt-get install -y curl build-essential libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN mkdir /myapp
WORKDIR /myapp
ENV BUNDLE_PATH /gems

ADD . /myapp