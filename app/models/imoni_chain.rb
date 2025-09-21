class ImoniChain < ApplicationRecord
  validates :new_ingredient, presence: true
  validates :creator_name, presence: true

  # 最新のチェーンを取得
  scope :recent, -> { order(created_at: :desc).limit(10) }

  # 基本の具材リスト
  BASIC_INGREDIENTS = %w[
    牛肉 豚肉 鶏肉 里芋 じゃがいも 人参 ごぼう ねぎ しめじ まいたけ 玉ねぎ 醤油 味噌
  ]

  # 特殊な具材（面白い反応を起こす）
  SPECIAL_INGREDIENTS = %w[
    バター カレー粉 チーズ うどん ラーメン キムチ チョコレート コーヒー ワイン ビール
  ]

  # 面白い組み合わせの定義
  FUNNY_COMBINATIONS = {
    %w[牛肉 豚肉] => { message: "肉の暴走！山形vs宮城の肉対決", chaos: 3 },
    %w[醤油 味噌] => { message: "禁断の融合！新時代の芋煮誕生", chaos: 2 },
    %w[里芋 じゃがいも] => { message: "芋×芋の相乗効果！ダブル芋パワー", chaos: 1 },
    %w[バター 醤油] => { message: "北海道が参戦！バター醤油の香り", chaos: 2 },
    %w[チーズ 味噌] => { message: "西洋×東洋のコラボレーション", chaos: 3 },
    %w[カレー粉 里芋] => { message: "芋煮カレー爆誕！これはアリなのか？", chaos: 4 },
    %w[うどん 醤油] => { message: "締めのうどん投入！芋煮→芋煮うどん", chaos: 1 },
    %w[キムチ 豚肉] => { message: "韓国風芋煮！辛さで新境地", chaos: 3 },
    %w[チョコレート ビール] => { message: "一体何が起こっているんだ...", chaos: 5 }
  }

  # 新しいチェーンを作成
  def self.create_new_chain(creator_name, custom_ingredient = nil)
    previous = recent.first

    new_chain = new(creator_name: creator_name)

    if previous
      # 前のチェーンを継承
      new_chain.base_ingredients = previous.ingredients_list.join(',')
    else
      # 最初のチェーンは基本の芋煮
      new_chain.base_ingredients = "里芋,牛肉,醤油"
    end

    # 新しい具材を追加（カスタムまたはランダム）
    if custom_ingredient
      new_chain.new_ingredient = custom_ingredient
    else
      new_chain.new_ingredient = random_ingredient
    end

    # 面白い組み合わせをチェック
    new_chain.check_combinations!
    new_chain.save!
    new_chain
  end

  # 全具材のリスト
  def ingredients_list
    base_list = base_ingredients ? base_ingredients.split(',') : []
    (base_list + [new_ingredient]).uniq.compact
  end

  # 全具材を文字列で表示
  def ingredients_text
    ingredients_list.join(' × ')
  end

  # カオス度を計算
  def calculate_chaos_level
    base_chaos = ingredients_list.length - 3 # 基本3つから増えた分
    special_chaos = ingredients_list.count { |ing| SPECIAL_INGREDIENTS.include?(ing) }
    [base_chaos + special_chaos, 0].max
  end

  # チェーン番号（何番目か）
  def chain_number
    ImoniChain.where('created_at <= ?', created_at).count
  end

  private

  def self.random_ingredient
    all_ingredients = BASIC_INGREDIENTS + SPECIAL_INGREDIENTS
    all_ingredients.sample
  end

  def check_combinations!
    current_ingredients = ingredients_list

    FUNNY_COMBINATIONS.each do |combo, reaction|
      if combo.all? { |ingredient| current_ingredients.include?(ingredient) }
        self.special_message = reaction[:message]
        self.chaos_level = reaction[:chaos]
        self.combo_rating = 5 # 面白い組み合わせは高評価
        return
      end
    end

    # 特別な組み合わせがない場合
    self.chaos_level = calculate_chaos_level
    self.combo_rating = rand(3..4) # 普通の評価
    self.special_message = generate_normal_message
  end

  def generate_normal_message
    messages = [
      "美味しそうな芋煮になりました！",
      "なかなか良い組み合わせです",
      "意外と合うかもしれません",
      "チャレンジングな芋煮ですね",
      "これは新しい発見かも？"
    ]
    messages.sample
  end
end
