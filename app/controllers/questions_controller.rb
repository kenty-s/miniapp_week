class QuestionsController < ApplicationController
  def step1; end

  def step2
    session[:seasoning] = params[:seasoning]

    # デバッグ情報をログに出力（本番環境確認用）
    Rails.logger.info "=== STEP2 DEBUG START ==="
    Rails.logger.info "Seasoning selected: #{session[:seasoning]}"
    Rails.logger.info "Code version: 2024-09-21-v3"

    # 選択した味付けに基づいて利用可能な肉をフィルタリング
    # 福島は醤油・味噌どちらでもOKなので、特別処理
    if session[:seasoning] == "醤油" || session[:seasoning] == "味噌"
      raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", session[:seasoning], "%#{session[:seasoning]}%")
                        .distinct
                        .pluck(:meat)
                        .uniq
      Rails.logger.info "Using special Fukushima logic for #{session[:seasoning]}"
    else
      raw_meats = Region.where(seasoning: session[:seasoning])
                        .distinct
                        .pluck(:meat)
                        .uniq
      Rails.logger.info "Using standard logic for #{session[:seasoning]}"
    end

    Rails.logger.info "Raw meats from DB: #{raw_meats.inspect}"

    # 鶏・豚の組み合わせを個別の選択肢に分解
    available_meats = []
    raw_meats.each do |meat|
      Rails.logger.info "Processing meat: #{meat}"
      meat.split('・').each do |individual_meat|
        Rails.logger.info "  Individual meat: #{individual_meat}"
        unless available_meats.include?(individual_meat)
          available_meats << individual_meat
          Rails.logger.info "    Added: #{individual_meat}"
        else
          Rails.logger.info "    Duplicate ignored: #{individual_meat}"
        end
      end
    end
    @available_meats = available_meats.sort

    Rails.logger.info "Final available_meats: #{@available_meats.inspect}"
    Rails.logger.info "=== STEP2 DEBUG END ==="
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
    # デバッグ情報をログに出力（本番環境確認用）
    Rails.logger.info "=== RESPECT DEBUG START ==="
    Rails.logger.info "Code version: 2024-09-21-v3"

    # 芋煮リスペクトページで使用するデータを準備
    # 各県から最初の1つのレコードのみ表示
    all_regions = Region.all.to_a
    Rails.logger.info "Total regions from DB: #{all_regions.count}"

    all_regions.each do |region|
      Rails.logger.info "Region ID #{region.id}: #{region.name} | #{region.seasoning} | #{region.meat} | #{region.feature}"
    end

    unique_regions = {}
    all_regions.each do |region|
      if unique_regions[region.name]
        Rails.logger.info "Duplicate detected for #{region.name}: skipping ID #{region.id}"
      else
        unique_regions[region.name] = region
        Rails.logger.info "First record for #{region.name}: using ID #{region.id}"
      end
    end

    @regions = unique_regions.values.group_by(&:name)
    Rails.logger.info "Final unique regions count: #{@regions.keys.count}"
    Rails.logger.info "=== RESPECT DEBUG END ==="
  end

end
