class DebugController < ApplicationController
  # 本番環境でのセキュリティ対策
  before_action :check_debug_access

  def index
    @debug_info = {
      environment: Rails.env,
      ruby_version: RUBY_VERSION,
      rails_version: Rails.version,
      timestamp: Time.current,
      code_version: "2024-09-21-v4-debug-page"
    }

    # データベース基本情報
    @database_info = {
      adapter: ActiveRecord::Base.connection.adapter_name,
      total_regions: Region.count,
      total_votes: Vote.count
    }

    # 全Regionレコード
    @all_regions = Region.all.order(:id).map do |r|
      {
        id: r.id,
        name: r.name,
        seasoning: r.seasoning,
        meat: r.meat,
        feature: r.feature
      }
    end

    # 重複チェック
    @duplicate_check = Region.group(:name).count.map do |name, count|
      {
        name: name,
        count: count,
        status: count > 1 ? "⚠️ 重複あり" : "✓ OK"
      }
    end

    # Step2ロジックのシミュレーション
    @step2_simulation = simulate_step2_logic

    # Respectページのシミュレーション
    @respect_simulation = simulate_respect_logic

    # SQLクエリテスト
    @sql_test = test_sql_queries
  end

  private

  def check_debug_access
    # 本番環境では一時的にアクセス可能、後で削除予定
    # 開発環境では常にアクセス可能
    unless Rails.env.development? || Rails.env.production?
      redirect_to root_path
    end
  end

  def simulate_step2_logic
    results = {}

    ["醤油", "味噌"].each do |seasoning|
      if seasoning == "醤油" || seasoning == "味噌"
        raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", seasoning, "%#{seasoning}%")
                          .distinct
                          .pluck(:meat)
                          .uniq
        logic_type = "special_fukushima"
      else
        raw_meats = Region.where(seasoning: seasoning)
                          .distinct
                          .pluck(:meat)
                          .uniq
        logic_type = "standard"
      end

      available_meats = []
      processing_details = []

      raw_meats.each do |meat|
        meat.split('・').each do |individual_meat|
          if available_meats.include?(individual_meat)
            processing_details << "#{individual_meat}: 重複のためスキップ"
          else
            available_meats << individual_meat
            processing_details << "#{individual_meat}: 追加"
          end
        end
      end

      results[seasoning] = {
        logic_type: logic_type,
        raw_meats: raw_meats,
        processing_details: processing_details,
        final_meats: available_meats.sort
      }
    end

    results
  end

  def simulate_respect_logic
    all_regions = Region.all.to_a
    unique_regions = {}
    processing_details = []

    all_regions.each do |region|
      if unique_regions[region.name]
        processing_details << "#{region.name}: 重複レコード ID #{region.id} をスキップ"
      else
        unique_regions[region.name] = region
        processing_details << "#{region.name}: 最初のレコード ID #{region.id} を使用"
      end
    end

    grouped_regions = unique_regions.values.group_by(&:name)

    {
      processing_details: processing_details,
      final_regions: grouped_regions.map do |name, regions|
        region = regions.first
        {
          name: name,
          seasoning: region.seasoning,
          meat: region.meat,
          feature: region.feature
        }
      end
    }
  end

  def test_sql_queries
    results = {}

    begin
      sql_result = ActiveRecord::Base.connection.execute(
        "SELECT name, COUNT(*) as count FROM regions GROUP BY name HAVING COUNT(*) > 1"
      )

      if sql_result.any?
        results[:duplicates] = sql_result.map { |row| "#{row['name']}: #{row['count']}件" }
        results[:status] = "⚠️ 重複検出"
      else
        results[:duplicates] = []
        results[:status] = "✓ 重複なし"
      end
    rescue => e
      results[:error] = e.message
      results[:status] = "❌ エラー"
    end

    results
  end
end
