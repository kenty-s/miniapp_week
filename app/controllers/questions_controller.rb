class QuestionsController < ApplicationController
  def step1; end

  def step2
    session[:seasoning] = params[:seasoning]

    # 選択した味付けに基づいて利用可能な肉をフィルタリング
    # 福島は醤油・味噌どちらでもOKなので、特別処理
    if session[:seasoning] == "醤油" || session[:seasoning] == "味噌"
      raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", session[:seasoning], "%#{session[:seasoning]}%")
                        .distinct
                        .pluck(:meat)
                        .uniq
    else
      raw_meats = Region.where(seasoning: session[:seasoning])
                        .distinct
                        .pluck(:meat)
                        .uniq
    end

    # 鶏・豚の組み合わせを個別の選択肢に分解（Setを使用して重複を完全排除）
    meat_set = Set.new
    raw_meats.each do |meat|
      if meat == "鶏・豚"
        meat_set.add("鶏")
        meat_set.add("豚")
      else
        meat_set.add(meat)
      end
    end
    @available_meats = meat_set.to_a
  end

  def step3
    session[:meat] = params[:meat]

    # 選択した味付けと肉に基づいて利用可能な特徴をフィルタリング
    # 鶏または豚を選択した場合は、鶏・豚の組み合わせも含める
    meat_conditions = []
    meat_params = []

    if session[:meat] == "鶏" || session[:meat] == "豚"
      meat_conditions << "(meat = ? OR meat LIKE ? OR meat = '鶏・豚')"
      meat_params += [session[:meat], "%#{session[:meat]}%"]
    else
      meat_conditions << "(meat = ? OR meat LIKE ?)"
      meat_params += [session[:meat], "%#{session[:meat]}%"]
    end

    # 福島は醤油・味噌どちらでもOKなので、特別処理
    if session[:seasoning] == "醤油" || session[:seasoning] == "味噌"
      @available_regions = Region.where(
        "(seasoning = ? OR seasoning LIKE ?) AND #{meat_conditions.join(' OR ')}",
        session[:seasoning], "%#{session[:seasoning]}%", *meat_params
      )
    else
      @available_regions = Region.where(
        "seasoning = ? AND #{meat_conditions.join(' OR ')}",
        session[:seasoning], *meat_params
      )
    end
    @available_features = @available_regions.pluck(:feature).uniq
  end

  def result
    session[:feature] = params[:feature]

    # 鶏または豚を選択した場合は、鶏・豚の組み合わせも含める検索条件を作成
    meat_condition = if session[:meat] == "鶏" || session[:meat] == "豚"
      "(meat = '#{session[:meat]}' OR meat LIKE '%#{session[:meat]}%' OR meat = '鶏・豚')"
    else
      "(meat = '#{session[:meat]}' OR meat LIKE '%#{session[:meat]}%')"
    end

    # 福島は醤油・味噌どちらでもOKなので、特別処理
    if session[:seasoning] == "醤油" || session[:seasoning] == "味噌"
      seasoning_condition = "(seasoning = ? OR seasoning LIKE ?)"
      seasoning_params = [session[:seasoning], "%#{session[:seasoning]}%"]
    else
      seasoning_condition = "seasoning = ?"
      seasoning_params = [session[:seasoning]]
    end

    # より柔軟な検索でマッチする地域を見つける
    @region = Region.where(
      "#{seasoning_condition} AND #{meat_condition} AND feature = ?",
      *seasoning_params, session[:feature]
    ).first

    # 特徴が一致しない場合は、味付けと肉だけで検索
    unless @region
      @region = Region.where(
        "#{seasoning_condition} AND #{meat_condition}",
        *seasoning_params
      ).first
    end

    # それでも見つからない場合は、味付けだけで検索
    unless @region
      @region = Region.where(seasoning_condition, *seasoning_params).first
    end

    if @region
      Vote.create!(region: @region)
    end
  end

  def respect
    # 芋煮リスペクトページで使用するデータを準備（各県1つのレコードのみ）
    @regions = Region.all.group_by(&:name).transform_values { |regions| [regions.first] }
  end

end
