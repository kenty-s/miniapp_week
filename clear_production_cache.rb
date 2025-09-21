# 本番環境キャッシュクリアスクリプト

puts "=== キャッシュクリア開始 ==="

# Railsキャッシュをクリア
puts "1. Railsキャッシュをクリア中..."
Rails.cache.clear
puts "   ✓ Rails.cache.clear 完了"

# アプリケーションキャッシュをクリア
puts "2. アプリケーションキャッシュをクリア中..."
if Rails.application.respond_to?(:reloader)
  Rails.application.reloader.reload!
  puts "   ✓ アプリケーションリロード 完了"
end

# ActiveRecordキャッシュをクリア
puts "3. ActiveRecordキャッシュをクリア中..."
ActiveRecord::Base.connection.schema_cache.clear!
puts "   ✓ ActiveRecord schema cache クリア 完了"

# クエリキャッシュをクリア
puts "4. クエリキャッシュをクリア中..."
ActiveRecord::Base.connection.clear_query_cache
puts "   ✓ Query cache クリア 完了"

# テンプレートキャッシュをクリア（開発環境のみ有効だが念のため）
puts "5. テンプレートキャッシュチェック中..."
if ActionView::Base.respond_to?(:cache_template_loading)
  puts "   - テンプレートキャッシュは本番環境では自動管理されています"
else
  puts "   - テンプレートキャッシュ設定なし"
end

puts "\n=== キャッシュクリア完了 ==="
puts "アプリケーションを再起動することを推奨します。"

# 現在のRegionデータを確認
puts "\n=== 現在のRegionデータ確認 ==="
puts "Total regions: #{Region.count}"
Region.group(:name).count.each do |name, count|
  puts "#{name}: #{count}件"
end