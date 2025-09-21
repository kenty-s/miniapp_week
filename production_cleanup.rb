# 本番環境のデータベースクリーンアップスクリプト

puts "Current regions count: #{Region.count}"
puts "Current votes count: #{Vote.count}"

# 現在のデータを表示
puts "\n現在のRegionデータ:"
Region.all.each do |r|
  puts "#{r.id}: #{r.name} - #{r.seasoning} - #{r.meat} - #{r.feature}"
end

# 各県名でグループ化して重複をチェック
duplicate_names = Region.group(:name).having('COUNT(*) > 1').pluck(:name)
puts "\n重複している県名: #{duplicate_names}"

if duplicate_names.any?
  puts "\n重複を解決します..."

  # 各重複県について、最初のレコード以外を削除
  duplicate_names.each do |name|
    regions = Region.where(name: name).order(:id)
    keep_region = regions.first
    delete_regions = regions[1..-1]

    puts "#{name}: 保持するID #{keep_region.id}, 削除するID #{delete_regions.map(&:id)}"

    # 削除対象のレコードを参照しているVoteを更新
    delete_regions.each do |region_to_delete|
      Vote.where(region: region_to_delete).update_all(region_id: keep_region.id)
      region_to_delete.destroy
    end
  end
end

puts "\nクリーンアップ後:"
puts "Regions count: #{Region.count}"
Region.all.each do |r|
  puts "#{r.id}: #{r.name} - #{r.seasoning} - #{r.meat} - #{r.feature}"
end