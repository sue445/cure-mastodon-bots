# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.6.3"

gem "activesupport", require: "active_support/all"
gem "dalli"
gem "global"
gem "holiday_jp"
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

  # TODO: Remove after https://github.com/onk/onkcop/pull/62 and https://github.com/onk/onkcop/pull/63 are merged
  # gem "onkcop", ">= 0.53.0.3", require: false
  gem "onkcop", require: false, github: "sue445/onkcop", branch: "rubocop_0.72.0"

  gem "pry-byebug", group: :test
  gem "rubocop-performance", require: false
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
