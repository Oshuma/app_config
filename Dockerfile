# This Dockerfile is only intended to run tests; see docker-compose.yml
FROM ruby:2.3-alpine

ARG GIT_VERSION
ARG BUILD_DATE

LABEL io.github.oshuma.comics.git-version=$GIT_VERSION \
      io.github.oshuma.comics.build-date=$BUILD_DATE

LABEL org.label-schema.vcs-ref=$GIT_VERSION \
      org.label-schema.vcs-url="https://github.com/Oshuma/app_config"

RUN apk add --update --no-cache \
      build-base \
      mysql-dev \
      postgresql-dev \
      sqlite-dev \
    && rm -rf /var/cache/apk/*

RUN mkdir /app_config
WORKDIR /app_config

ADD APP_CONFIG_VERSION /app_config/APP_CONFIG_VERSION
ADD app_config.gemspec /app_config/app_config.gemspec
ADD Gemfile /app_config/Gemfile
ADD Gemfile.lock /app_config/Gemfile.lock

RUN bundle install

ADD . /app_config
