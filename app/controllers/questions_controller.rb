class QuestionsController < ApplicationController
  def step1; end

  def step2
    session[:seasoning] = params[:seasoning]

    # 選択した味付けに基づいて利用可能な肉をフィルタリング
    raw_meats = Region.where(seasoning: session[:seasoning])
                      .distinct
                      .pluck(:meat)
                      .uniq

    # 鶏・豚の組み合わせを個別の選択肢に分解
    @available_meats = []
    raw_meats.each do |meat|
      if meat == "鶏・豚"
        @available_meats << "鶏" unless @available_meats.include?("鶏")
        @available_meats << "豚" unless @available_meats.include?("豚")
      else
        @available_meats << meat unless @available_meats.include?(meat)
      end
    end
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

    @available_regions = Region.where(
      "seasoning = ? AND #{meat_conditions.join(' OR ')}",
      session[:seasoning], *meat_params
    )
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

    # より柔軟な検索でマッチする地域を見つける
    @region = Region.where(
      "seasoning = ? AND #{meat_condition} AND feature = ?",
      session[:seasoning], session[:feature]
    ).first

    # 特徴が一致しない場合は、味付けと肉だけで検索
    unless @region
      @region = Region.where(
        "seasoning = ? AND #{meat_condition}",
        session[:seasoning]
      ).first
    end

    # それでも見つからない場合は、味付けだけで検索
    unless @region
      @region = Region.where(seasoning: session[:seasoning]).first
    end

    if @region
      Vote.create!(region: @region)
    end
  end

end
