require_relative "bot"
require_relative "birthday_calendar_client"

class BirthdayBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_BIRTHDAY"])
  end

  def perform
    today = Time.current.to_date

    message = BirthdayBot.generate_message(today)

    if message
      post_message(message)
    else
      puts "#{today} is not nobody's birthday"
    end
  end

  # @param date [Date]
  # @return [String]
  def self.generate_message(date)
    names = BirthdayCalendarClient.new.find_by_birthday(date)

    return nil if names.empty?

    "今日は#{names.join("、")}の誕生日です！ https://sue445.github.io/precure-birthday-calendar/"
  end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  BirthdayBot.new.perform
end
