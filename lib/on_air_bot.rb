require_relative "./bot"
require_relative "./program"

class OnAirBot < Bot
  DELAY_MINUTES = 10
  RANGE_MINUTES = 30

  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_ON_AIR"])
  end

  def perform
    on_air_programs = current_programs

    return if on_air_programs.empty?

    Program.each_with_same_story_number(on_air_programs) do |program, ch_names|
      message = generate_message(program, ch_names)
      post_message(message)
    end
  end

  private

    def current_programs
      current_time = Time.current
      min = current_time.min - (current_time.min % 10)
      start_at = current_time.change(min: min, sec: 0) + DELAY_MINUTES.minutes
      end_at = start_at + RANGE_MINUTES.minutes

      Program.programs(start_at: start_at, end_at: end_at, squeeze: true)
    end

    def generate_message(program, ch_names)
      message = Program.format_program(program, ch_names)

      message << "\nこのあとすぐ！\n"

      message.strip
    end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  OnAirBot.new.perform
end
