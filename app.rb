begin
  require "dotenv"
  Dotenv.load
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

Bundler.require(:default, ENV["RACK_ENV"])

require "rollbar/middleware/sinatra"

class App < Sinatra::Base
  use Rollbar::Middleware::Sinatra

  get "/" do
    today = Time.current.to_date
    @date_girls = girl_birthdays(today, today + 3.months)
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
  end
end
