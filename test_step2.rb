# Step2メソッドのテスト

puts "=== Step2ロジックテスト ==="

# 醤油選択のシミュレーション
seasoning = "醤油"
puts "\n醤油選択時:"
puts "Seasoning selected: #{seasoning}"

if seasoning == "醤油" || seasoning == "味噌"
  raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", seasoning, "%#{seasoning}%")
                    .distinct
                    .pluck(:meat)
                    .uniq
  puts "Using special Fukushima logic for #{seasoning}"
else
  raw_meats = Region.where(seasoning: seasoning)
                    .distinct
                    .pluck(:meat)
                    .uniq
  puts "Using standard logic for #{seasoning}"
end

puts "Raw meats from DB: #{raw_meats.inspect}"

available_meats = []
raw_meats.each do |meat|
  puts "Processing meat: #{meat}"
  meat.split('・').each do |individual_meat|
    puts "  Individual meat: #{individual_meat}"
    unless available_meats.include?(individual_meat)
      available_meats << individual_meat
      puts "    Added: #{individual_meat}"
    else
      puts "    Duplicate ignored: #{individual_meat}"
    end
  end
end

final_available_meats = available_meats.sort
puts "Final available_meats: #{final_available_meats.inspect}"

# 味噌選択のシミュレーション
seasoning = "味噌"
puts "\n味噌選択時:"
puts "Seasoning selected: #{seasoning}"

if seasoning == "醤油" || seasoning == "味噌"
  raw_meats = Region.where("seasoning = ? OR seasoning LIKE ?", seasoning, "%#{seasoning}%")
                    .distinct
                    .pluck(:meat)
                    .uniq
  puts "Using special Fukushima logic for #{seasoning}"
else
  raw_meats = Region.where(seasoning: seasoning)
                    .distinct
                    .pluck(:meat)
                    .uniq
  puts "Using standard logic for #{seasoning}"
end

puts "Raw meats from DB: #{raw_meats.inspect}"

available_meats = []
raw_meats.each do |meat|
  puts "Processing meat: #{meat}"
  meat.split('・').each do |individual_meat|
    puts "  Individual meat: #{individual_meat}"
    unless available_meats.include?(individual_meat)
      available_meats << individual_meat
      puts "    Added: #{individual_meat}"
    else
      puts "    Duplicate ignored: #{individual_meat}"
    end
  end
end

final_available_meats = available_meats.sort
puts "Final available_meats: #{final_available_meats.inspect}"

puts "\n=== テスト完了 ==="