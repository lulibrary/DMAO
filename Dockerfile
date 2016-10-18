FROM ruby:2.3.1-slim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV APP_ROOT /var/www/dmao
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
ADD Gemfile* $APP_ROOT/
RUN bundle install
ADD . $APP_ROOT

EXPOSE 80

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]