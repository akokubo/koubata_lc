# 幸畑プロジェクト(仮称):エコマネーアプリケーション

これは、幸畑プロジェクト(仮称)で実証実験に使用するために開発しているエコマネーアプリケーションです。

Ruby on Rails 4.1で開発しています。

## インストール

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

by [Atsushi Kokubo](https://twitter.com/akokubo).
