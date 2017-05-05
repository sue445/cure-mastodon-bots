require_relative "./bot"

class OnAirBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_ON_AIR"])
  end

  def perform
  end

  # @param start_at [Time]
  # @param end_at   [Time]
  def self.programs(start_at, end_at)
    prog_items = Syobocal::CalChk.get(start: start_at.to_date, days: 1)
    prog_items.select do |item|
      (start_at...end_at).cover?(item[:st_time])
    end
  end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  OnAirBot.new.perform
end
