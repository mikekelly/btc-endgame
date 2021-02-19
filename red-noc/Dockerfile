FROM ruby:3.0.0-alpine3.13

WORKDIR /usr/src/app

RUN apk add --update build-base libffi-dev libcurl git

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["bundle exec ruby find_them_and_destroy_them.rb"]
