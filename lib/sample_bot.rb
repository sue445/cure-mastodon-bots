require_relative "bot"

class SampleBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_SAMPLE"])
  end

  def perform
    series_title = Precure.map(&:title).sample
    post_message(series_title)
  end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  SampleBot.new.perform
end
