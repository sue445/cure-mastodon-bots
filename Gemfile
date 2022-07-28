# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.0.4"

gem "activesupport", require: "active_support/all"
gem "dalli"
gem "global"
gem "holiday_jp"
gem "libxml-ruby"
gem "mastodon-api", require: "mastodon"
gem "puma"
gem "puma-heroku"
gem "rake", require: false
gem "rollbar"
gem "rubicure"
gem "sinatra"
gem "slim"
gem "syobocalite"

group :development do
  gem "dotenv"
  gem "foreman", require: false
  gem "onkcop", ">= 1.0.0.0", require: false
  gem "pry-byebug", group: :test
  gem "rubocop_auto_corrector", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", ">= 2.0.0.pre", require: false
end

group :test do
  gem "coveralls", ">= 0.8", require: false
  gem "rack-test"
  gem "rspec"
  gem "rspec-its"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end
