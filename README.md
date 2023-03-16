| Task |      |
| ---- | ---- |
| Column | Type |
| id | integer |
| title | string |
| content | text |

デプロイ手順

1.githubにアプリをpushする
2.heroku create アプリ名（今回はmanyo）でアプリ作成
3.heroku login -iでherokuにログイン。パスワードはherokuのAPIキー
4.git push heroku step2:master を実行してデプロイする。