begin
  require "dotenv"
  Dotenv.load
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

Bundler.require(:default, ENV["RACK_ENV"])

require "rollbar/middleware/sinatra"
require_relative "./lib/on_air_bot"

class App < Sinatra::Base
  use Rollbar::Middleware::Sinatra

  BIRTHDAY_MONTHS = 3
  PROGRAM_WEEKS = 2

  before do
    Time.zone = "Tokyo"
  end

  get "/" do
    today = Time.current.to_date
    @date_girls = girl_birthdays(today, today + BIRTHDAY_MONTHS.months)
    @precure_programs = fetch_cache("precure_programs") do
      OnAirBot.programs(today, today + PROGRAM_WEEKS.weeks).select{ |program| program[:title].include?(OnAirBot::NOTIFY_TITLE) }
    end
    slim :index
  end

  helpers do
    def girl_birthdays(from_date, to_date)
      date_girls = {}
      girls = Precure.all.select(&:have_birthday?)

      from_year = from_date.year
      to_year = to_date.year
      girls.each do |girl|
        (from_year..to_year).each do |year|
          date = Date.parse("#{year}/#{girl.birthday}")
          date_girls[date] = girl
        end
      end

      date_girls.select! { |date, _girl| (from_date..to_date).cover?(date) }

      Hash[date_girls.sort]
    end

    def fetch_cache(key)
      cache = cache_client

      begin
        cached_response = cache.get(key)
        return cached_response if cached_response
      rescue => e
        logger.warn(e)
        Rollbar.warning(e)
      end

      response = yield

      begin
        cache.set(key, response)
      rescue => e
        logger.warn(e)
        Rollbar.warning(e)
      end

      response
    end

    def cache_client
      options = { namespace: "cure-mastodon-bots", compress: true, expires_in: 5.minutes }

      Dalli.logger.level = Logger::WARN

      if ENV["MEMCACHEDCLOUD_SERVERS"]
        # Heroku
        options[:username] = ENV["MEMCACHEDCLOUD_USERNAME"]
        options[:password] = ENV["MEMCACHEDCLOUD_PASSWORD"]
        Dalli::Client.new(ENV["MEMCACHEDCLOUD_SERVERS"].split(","), options)
      else
        # localhost
        Dalli::Client.new("localhost:11211", options)
      end
    end
  end
end
