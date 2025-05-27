FROM ruby:3.2.3

ENV RUBYOPT="-rlogger"
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

# Node.js と Yarn のインストール
RUN apt-get update -qq && apt-get install -y curl gnupg

# Node.js（最新版 LTS の 18.x）をインストール
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# yarnパッケージ管理ツールをインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY . /myapp

RUN yarn install --check-files

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Railsサーバー起動
CMD ["rails", "server", "-b", "0.0.0.0"]