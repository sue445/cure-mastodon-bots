# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.1"

gem "dalli"
gem "global"
gem "jemalloc", require: false
gem "mastodon-api", require: "mastodon"
gem "puma"
gem "rake", require: false
gem "rollbar"
gem "rubicure"
gem "sinatra"
gem "slim"
gem "syobocal", github: "sue445/syobocal", branch: "time_with_zone", ref: "76cf9b"

group :development do
  gem "dotenv"
  gem "foreman", require: false
  gem "onkcop", require: false
end

group :test do
  gem "rack-test"
  gem "rspec"
  gem "rspec-its"
  gem "timecop"
  gem "webmock"
end
