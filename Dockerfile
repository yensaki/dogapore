FROM jrottenberg/ffmpeg:4.1 as ffmpeg

FROM ruby:2.7.1

RUN apt-get update \
  && apt-get install -y ffmpeg \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN gem install bundler && bundle install

COPY --from=ffmpeg /usr/local /usr/local

COPY . ./

CMD ["ruby", "./app.rb"]

