require_relative "bot"

class SampleBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_SAMPLE"])
  end

  def perform
    post_message("Test #{Time.now}")
  end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  SampleBot.new.perform
end
