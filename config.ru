require "./app"
require "rollbar"

Rollbar.configure do |config|
  config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  config.enabled      = ENV["ROLLBAR_ACCESS_TOKEN"].present?

  config.exception_level_filters.merge!(
    "Sinatra::NotFound" => "ignore",
  )
end

run App
