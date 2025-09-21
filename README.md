# この芋煮論争を終わらせに来た!!!

東北地方の秋の風物詩「芋煮」をテーマにした診断型Webアプリケーションです。
ユーザーの好みに基づいて最適な芋煮スタイルを判定し、県別の芋煮文化を楽しく紹介します。

## 概要

このアプリケーションは以下の要素で構成されています：
- ユーザーの味付け・食材の好みを3ステップで診断
- 県別の芋煮スタイルとの適合性を判定
- 芋煮文化に関する情報提供

## 芋煮に関する情報源

芋煮の地域性や文化的背景について、以下の情報を参考にしています：

> 「芋煮は東北地方の代表的な郷土料理であり、地域によって味付けや具材に大きな違いがある。特に山形県の醤油ベース、宮城県の味噌ベースの対立は有名である。」
>
> （出典：[全日本芋煮会同好会公式サイト](https://imonikai.jp/imoni-map/) ©全日本芋煮会同好会）

## 参考情報
- 令和ロマンのご様子　S14-7
  https://x.com/goyousu_reiwa/status/1882011305575596166


## 機能
- 3ステップの芋煮診断フォーム
- 県別芋煮スタイル判定システム
- Font Awesomeアイコンを使用したモダンなUI
- Tailwind CSSによるレスポンシブデザイン

## 技術スタック
- Ruby 3.3.6
- Rails 8.0.2+
- PostgreSQL (Docker)
- Tailwind CSS 4.x
- Font Awesome 6.4.0
- Hotwire (Turbo + Stimulus)

## 起動方法
```bash
docker compose up -d
docker compose exec web rails db:create db:migrate db:seed
```

## プロジェクト構成

```
app/
├── controllers/
│   ├── home_controller.rb          # トップページ
│   ├── questions_controller.rb     # 診断フロー
│   └── posts_controller.rb         # 基本CRUD
├── views/
│   ├── home/
│   │   └── index.html.slim         # ランディングページ
│   ├── questions/
│   │   ├── step1.html.slim         # 味付け選択
│   │   ├── step2.html.slim         # 肉類選択
│   │   ├── step3.html.slim         # 特徴選択
│   │   └── result.html.slim        # 結果表示
│   └── layouts/
│       └── application.html.erb     # 共通レイアウト
└── assets/
    └── stylesheets/
        └── application.tailwind.css # カスタムスタイル
```

## 今後の拡張予定

- 東北地図での結果可視化
- アニメーション演出の強化
- 投票データの永続化
