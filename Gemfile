# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.1"

gem "dalli"
gem "global"
gem "hashie"
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
  gem "pry-byebug", group: :test
end

group :test do
  gem "codeclimate-test-reporter", require: false
  gem "coveralls", require: false
  gem "rack-test"
  gem "rspec"
  gem "rspec-its"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end
