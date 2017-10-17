require_relative "./bot"
require_relative "./program"

class TodayOnAirBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_ON_AIR"])
  end

  def perform
    on_air_programs = current_programs

    return if on_air_programs.empty?

    message = "今日のプリキュア\n"

    Program.each_with_same_story_number(on_air_programs) do |program, ch_names|
      message << "\n"
      message << Program.format_program(program, ch_names)
    end

    post_message(message.strip)
  end

  private

    def current_programs
      current_time = Time.current

      start_at = current_time.beginning_of_day
      end_at = current_time.end_of_day

      Program.programs(start_at: start_at, end_at: end_at, squeeze: true)
    end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  TodayOnAirBot.new.perform
end
