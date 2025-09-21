# 本番環境デバッグスクリプト

puts "=== 環境情報 ==="
puts "Rails.env: #{Rails.env}"
puts "Ruby version: #{RUBY_VERSION}"
puts "Rails version: #{Rails.version}"

puts "\n=== Regionデータ ==="
puts "Total regions: #{Region.count}"
Region.all.each do |r|
  puts "ID #{r.id}: #{r.name} | #{r.seasoning} | #{r.meat} | #{r.feature}"
end

puts "\n=== 県名ごとのレコード数 ==="
Region.group(:name).count.each do |name, count|
  puts "#{name}: #{count}件"
end

puts "\n=== 醤油選択時のStep2テスト ==="
seasoning = "醤油"
raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", seasoning, "%#{seasoning}%")
                  .distinct
                  .pluck(:meat)
                  .uniq
puts "Raw meats for 醤油: #{raw_meats.inspect}"

# 肉の分解処理
available_meats = []
raw_meats.each do |meat|
  meat.split('・').each do |individual_meat|
    available_meats << individual_meat unless available_meats.include?(individual_meat)
  end
end
puts "Available meats for 醤油: #{available_meats.sort.inspect}"

puts "\n=== 味噌選択時のStep2テスト ==="
seasoning = "味噌"
raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", seasoning, "%#{seasoning}%")
                  .distinct
                  .pluck(:meat)
                  .uniq
puts "Raw meats for 味噌: #{raw_meats.inspect}"

# 肉の分解処理
available_meats = []
raw_meats.each do |meat|
  meat.split('・').each do |individual_meat|
    available_meats << individual_meat unless available_meats.include?(individual_meat)
  end
end
puts "Available meats for 味噌: #{available_meats.sort.inspect}"