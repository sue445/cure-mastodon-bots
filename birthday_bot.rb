require_relative "./bot"

class BirthdayBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_BIRTHDAY"])
  end

  def perform
    today = Time.current.to_date

    birthday_girls = Precure.all.select { |girl| girl.birthday?(today) }

    if birthday_girls.empty?
      puts "#{today} is not nobody's birthday"
    else
      birthday_girls.each do |girl|
        post_message("今日は#{girl.precure_name}（Cv. #{girl.cast_name}）の誕生日です！ https://github.com/sue445/cure-mastodon-bots")
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  BirthdayBot.new.perform
end
