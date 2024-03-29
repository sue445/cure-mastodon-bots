require_relative "bot"
require_relative "program_manager"

class TodayOnAirBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_ON_AIR"])
  end

  def perform
    on_air_programs = current_programs

    if on_air_programs.empty?
      puts "Doesn't found on air programs"
      return
    end

    message = "今日のプリキュア\n"

    ProgramManager.each_with_same_story_number(on_air_programs) do |program, ch_names|
      message << "\n"
      message << program.format(ch_names)
    end

    post_message(message.strip)
  end

  private

    def current_programs
      current_time = Time.current

      start_at = current_time.beginning_of_day
      end_at = current_time.end_of_day

      ProgramManager.search(start_at:, end_at:, squeeze: true)
    end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  TodayOnAirBot.new.perform
end
