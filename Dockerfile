FROM jrottenberg/ffmpeg:4.1 as ffmpeg

FROM ruby:2.7.1

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN gem install bundler && bundle install

COPY --from=ffmpeg /usr/local /usr/local
# ffmpeg 不足あり

COPY . ./

CMD ["ruby", "./app.rb"]

