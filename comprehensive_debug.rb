# 包括的デバッグスクリプト

puts "=" * 60
puts "包括的デバッグ情報 - #{Time.current}"
puts "=" * 60

puts "\n=== 環境情報 ==="
puts "Rails.env: #{Rails.env}"
puts "Ruby version: #{RUBY_VERSION}"
puts "Rails version: #{Rails.version}"
puts "Git commit hash: #{`git rev-parse HEAD`.strip rescue 'N/A'}"

puts "\n=== データベース情報 ==="
puts "Database adapter: #{ActiveRecord::Base.connection.adapter_name}"
puts "Total regions: #{Region.count}"
puts "Total votes: #{Vote.count}"

puts "\n=== 全Regionレコード ==="
Region.all.order(:id).each do |r|
  puts "ID #{r.id}: #{r.name} | #{r.seasoning} | #{r.meat} | #{r.feature}"
end

puts "\n=== 重複チェック ==="
duplicate_counts = Region.group(:name).count
duplicate_counts.each do |name, count|
  status = count > 1 ? "⚠️  重複あり" : "✓ OK"
  puts "#{name}: #{count}件 #{status}"
end

puts "\n=== コントローラーメソッドテスト ==="

# Step2メソッドのシミュレーション (醤油)
puts "\n--- 醤油選択時のStep2処理 ---"
seasoning = "醤油"
raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", seasoning, "%#{seasoning}%")
                  .distinct
                  .pluck(:meat)
                  .uniq
puts "SQL実行結果 raw_meats: #{raw_meats.inspect}"

available_meats = []
raw_meats.each do |meat|
  puts "Processing meat: #{meat.inspect}"
  meat.split('・').each do |individual_meat|
    puts "  - Individual meat: #{individual_meat.inspect}"
    unless available_meats.include?(individual_meat)
      available_meats << individual_meat
      puts "    Added to available_meats"
    else
      puts "    Already in available_meats"
    end
  end
end
puts "Final available_meats for 醤油: #{available_meats.sort.inspect}"

# Step2メソッドのシミュレーション (味噌)
puts "\n--- 味噌選択時のStep2処理 ---"
seasoning = "味噌"
raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", seasoning, "%#{seasoning}%")
                  .distinct
                  .pluck(:meat)
                  .uniq
puts "SQL実行結果 raw_meats: #{raw_meats.inspect}"

available_meats = []
raw_meats.each do |meat|
  puts "Processing meat: #{meat.inspect}"
  meat.split('・').each do |individual_meat|
    puts "  - Individual meat: #{individual_meat.inspect}"
    unless available_meats.include?(individual_meat)
      available_meats << individual_meat
      puts "    Added to available_meats"
    else
      puts "    Already in available_meats"
    end
  end
end
puts "Final available_meats for 味噌: #{available_meats.sort.inspect}"

puts "\n=== Respectページテスト ==="
all_regions = Region.all.to_a
unique_regions = {}
all_regions.each do |region|
  if unique_regions[region.name]
    puts "⚠️  #{region.name} の重複レコード発見: ID #{region.id}"
  else
    unique_regions[region.name] = region
    puts "✓ #{region.name} の最初のレコード設定: ID #{region.id}"
  end
end

grouped_regions = unique_regions.values.group_by(&:name)
puts "\nRespectページ用grouped_regions:"
grouped_regions.each do |name, regions|
  regions.each do |region|
    puts "#{name}: #{region.seasoning} | #{region.meat} | #{region.feature}"
  end
end

puts "\n=== SQL直接実行テスト ==="
begin
  sql_result = ActiveRecord::Base.connection.execute("SELECT name, COUNT(*) as count FROM regions GROUP BY name HAVING COUNT(*) > 1")
  if sql_result.any?
    puts "⚠️  SQL検出の重複:"
    sql_result.each do |row|
      puts "  #{row['name']}: #{row['count']}件"
    end
  else
    puts "✓ SQL検出では重複なし"
  end
rescue => e
  puts "❌ SQL実行エラー: #{e.message}"
end

puts "\n" + "=" * 60
puts "デバッグ完了"
puts "=" * 60