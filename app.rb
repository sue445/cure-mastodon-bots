begin
  require "dotenv"
  Dotenv.load
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"])

require "rollbar/middleware/sinatra"
require_relative "./lib/on_air_bot"
require_relative "./lib/cache_utils"

class App < Sinatra::Base
  use Rollbar::Middleware::Sinatra

  BIRTHDAY_MONTHS = 3
  PROGRAM_WEEKS = 5

  before do
    Time.zone = "Tokyo"

    Global.configure do |config|
      config.environment = ENV["RACK_ENV"]
      config.config_directory = "#{__dir__}/config/global"
    end
  end

  get "/" do
    today = Time.current.to_date
    @date_girls = girl_birthdays(today, today + BIRTHDAY_MONTHS.months)
    @precure_programs = precure_programs
    slim :index
  end

  helpers CacheUtils

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

    def precure_programs
      today = Time.current.beginning_of_day
      fetch_cache("precure_programs") do
        OnAirBot.programs(today, today + PROGRAM_WEEKS.weeks).select { |program| program[:title].include?(OnAirBot::NOTIFY_TITLE) }
      end
    end

    def week_class(time)
      date = time.to_date

      if HolidayJp.holiday?(date) || date.sunday?
        # red
        "danger"
      elsif date.saturday?
        # blue
        "info"
      end
    end
  end
end
