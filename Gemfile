# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.4.1"

gem "mastodon-api", require: "mastodon"
gem "rake", require: false
gem "rollbar"
gem "rubicure"
gem "syobocal"

group :development do
  gem "dotenv"
  gem "onkcop", require: false
end

group :test do
  gem "rspec"
  gem "rspec-its"
  gem "timecop"
  gem "webmock"
end
