require_relative "./bot"

class SampleBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["SAMPLE_ACCESS_TOKEN"])
  end

  def perform
    girl = Precure.all_girls.sample
    post_message(girl.precure_name)
  end
end

if $0 == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  SampleBot.new.perform
end
