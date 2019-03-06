FROM ruby:2.5-slim
RUN apt-get update -qq && apt-get install -y curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn build-essential libpq-dev chromium chromedriver
RUN mkdir /myapp
WORKDIR /myapp
ENV RAILS_ROOT /myapp
ENV BUNDLE_PATH /gems

ADD . /myapp