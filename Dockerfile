FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y imagemagick 

WORKDIR /usr/src/app/

COPY Gemfile Gemfile.lock ./
RUN bundle install

ADD . /usr/src/app/

EXPOSE 3333

#CMD ["ruby", "/usr/src/app/app.rb"]
