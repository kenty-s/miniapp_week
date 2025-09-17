# 芋煮ケーション 🍲
東北地方の秋の風物詩「芋煮」。山形 vs 宮城に代表される論争は長年決着がついていません。
本アプリは「イモニシャンクス」が登場し、ユーザーの投票でこの戦争を終わらせる(!?) Rails製ミニアプリです。

## 機能
- オープニング演出：「この戦争を終わらせに来た!!!」
- 芋煮の条件を3ページで質問
- 投票先を自動判定し、その県に投票
- 投票ランキングを表示（グラフ or 地図付き）

## 開発環境
- Ruby 3.2
- Rails 7.x
- PostgreSQL (Docker)

## 起動方法
```bash
docker compose up -d
docker compose exec web rails db:create db:migrate db:seed
```

## 今後の拡張

- 東北地図に投票率を反映
- アニメーション演出追加

app/assets/images/
  imoni_background.png
  imoni_shanks.png
  slash_effect.png# Updated at Thu Sep 18 05:06:44 JST 2025
