namespace :guest_user do
  desc "一定期間経過したゲストユーザーを削除する"
  task cleanup: :environment do
    # 例：1時間以上前に作られたゲストを削除
    expiration_time = 1.hour.ago

    users = User.where(guest: true).where(created_at: ...expiration_time)

    puts "🧹 削除対象ゲストユーザー数: #{users.count}"
    users.find_each do |user|
      user.destroy!
      puts "✅ ゲストユーザー削除: #{user.email}"
    end
  end
end
