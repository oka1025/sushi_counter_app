set :environment, 'production'  # 本番環境では 'production' に

# cron環境変数の指定
env :PATH, ENV.fetch('PATH', nil)
env :BUNDLE_GEMFILE, "/myapp/Gemfile"
env :BUNDLE_PATH, "/usr/local/bundle"
env :GEM_HOME, '/usr/local/bundle'
env :GEM_PATH, '/usr/local/bundle'

# rakeコマンドの定義
job_type :rake, <<~CMD.strip
  cd :path && bundle exec rake :task RAILS_ENV=:environment >> log/cron.log 2>&1
CMD

every 1.hour do
  rake "guest_user:cleanup"
  command "echo '✅ CRON CHECK: #{Time.zone.now}' >> log/cron.log 2>&1"
end
