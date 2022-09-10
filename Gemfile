# frozen_string_literal: true

source "https://rubygems.org"

gem "activesupport", require: "active_support/all"
gem "libxml-ruby"

# FIXME: Workaround for FrozenError: can't modify frozen String: ""
# c.f. https://github.com/mastodon/mastodon-api/issues/49
# gem "mastodon-api", require: "mastodon"
gem "mastodon-api", require: "mastodon", github: "ashphy/mastodon-api", branch: "master", ref: "69adfb4" # https://github.com/ashphy/mastodon-api/commit/69adfb4f6c4fd77874e4a3f6f3e335aecbf3c794

gem "rake", require: false
gem "rubicure"
gem "syobocalite"

group :development do
  gem "dotenv"
  gem "onkcop", ">= 1.0.0.0", require: false
  gem "rubocop_auto_corrector", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", ">= 2.0.0.pre", require: false
end

group :test do
  gem "coveralls", ">= 0.8", require: false
  gem "rspec"
  gem "rspec-its"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end
