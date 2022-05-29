FROM ruby:3.1.2

ENV LANG C.UTF-8
WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config set --local path 'vendor/bundle'
#RUN bundle install
RUN touch test.aaa
#COPY . /app

# nodeのインストール
#RUN apt-get update \
#    && apt-get install -y gnupg \
#    && curl -sL https://deb.nodesource.com/setup_14.x | bash \
#    && apt-get install -y nodejs \
#    && npm install -g yarn

EXPOSE 3000

#CMD ["rails", "server", "-b", "0.0.0.0"]
