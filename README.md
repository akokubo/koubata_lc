# 幸畑プロジェクト(仮称):エコマネーアプリケーション

これは、幸畑プロジェクト(仮称)で実証実験に使用するために開発しているエコマネーアプリケーションです。

Ruby on Rails 4.1で開発しています。

## インストール

* ER図やクラス図を生成するのにgraphvizを使用しており、事前にインストールが必要です。使わない場合はGemfileの`rails-erd`と`railroady`のgemをコメントアウトします。

```
git clone https://github.com/akokubo/koubata_lc.git
cd koubata_lc
bundle install --without production
bin/rake db:create
bin/rake db:migrate
bin/rake db:seed
bin/rake db:create RAILS_ENV=test
bin/rspec spec
bin/rails server
```

## ER図

ER図が`doc/erd.pdf`および`doc/erd.png`に入っています。

ER図を生成するには以下のコマンドを実行

```
bin/rake generate_erd
```

## クラス図

モデルとコントローラーのクラス図が`doc`に入っています。

クラス図を生成するには以下のコマンドを実行


```
bin/rake diagram:all
```


by [Atsushi Kokubo](https://twitter.com/akokubo).
