# fcm-monaca-rails for newest

以下サービスの各サービスのバージョンアップをしたもの。
https://github.com/bon10/fcm-rails-sample

## 各サービスバージョン

* Ruby version
3.1.2

* System dependencies
  * PostgreSQL 14.2
  * Monaca
  * Docker

## How to Develop

Delete the line `platform: linux/amd64` in docker-compose.yml If you use something other than M1 mac.

```
cd docker
docker compose up
```

ログインは別ターミナルを開いて以下を実行
```
docker exec -it fcm-monaca-rails /bin/bash
```

ログインした状態でDBのマイグレートとテストデータのインサートを実施
```
bundle exec rails db:migrate
bundle exec rails db:seed
```

### その他設定

#### .envの設定

fcm_sample にある .env.sample を .env にリネームし、自身のFirebaseの設定を反映する。

* FCM_SERVER_KEY プロジェクトの設定 > クラウドメッセージング > サーバーキー
* PROJECT_ID プロジェクトの設定 > 全般 > プロジェクトID
* SERVICE_ACOUNT_PATH プロジェクトの設定 > サービスアカウント > 「新しい秘密鍵の生成」で作ったjson  
これを fcm_sample 配下においた場合は xxxxx.json が設定値になる。

### Herokuデプロイなど

本番環境などファイルパスが使えない場合は、サービスアカウントのJSONファイルの値について、以下のように環境変数を定義する

```
GOOGLE_ACCOUNT_TYPE='service_account'
GOOGLE_CLIENT_ID='000000000000000000000'
GOOGLE_CLIENT_EMAIL='xxxx@xxxx.iam.gserviceaccount.com'
GOOGLE_PRIVATE_KEY='-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n\'
FCM_SERVER_KEY='your firebase server key'
```

Herokuの場合は以下のようにして heroku コマンドで定義するか、 ダッシュボードから都度追加する。（追加後はHerokuのdynosを再起動する）

```
heroku config:set GOOGLE_ACCOUNT_TYPE="service_account"
```

### Monaca

FirebaseのCordovaプラグインを用いてプッシュ通知に対応。
参照: https://ja.docs.monaca.io/tutorials/firebase

インポートしたCordovaプラグインの説明
・dpa99c/cordova-plugin-firebasex
　Firebaseを使う
・InAppBrowser
　Monacaでブラウザを使う
・Whitelist
　Monacaで外部サイトを開く(※)

※ config.xmlへ追記が必要

#### 動作概要

毎回アプリを開くたびにtokenをサーバーに連携しつつ、指定したWebサービスをInAppBrowserで開くという処理を実施。
ただFirebaseのトークンは有効期限が1時間しかないため、
現在の実装だとアプリを開いたまま1時間経過するとPush通知が届かなくなる可能性有。

制約としてはAndroidのアプリにバッジが付かない。(←仕様。Android本体の実装がメーカーによって異なるため)
iOS側にバッジをつけるにはgetBadgeNumberやsetBadgeNumberを使えば実装可能と推測。

### サーバー(このアプリ)

Rails7になった以外は基本的に以下と同様。
https://github.com/bon10/fcm-rails-sample

`/token` に対してMonacaから連携されてきたFirebaseのトークンをMonacaのIDとで関連付けてユーザーを特定。  
サーバーサイドですべての処理を実装することもできますが、その際はFirebaseとサーバーサイド側のユーザー管理を同期する必要有。
