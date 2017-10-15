require_relative "./bot"
require_relative "./syobocal_utils"

class OnAirBot < Bot
  NOTIFY_TITLE = "プリキュア".freeze
  DELAY_MINUTES = 10
  RANGE_MINUTES = 30

  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_ON_AIR"])
  end

  def perform
    on_air_programs = current_programs.select { |program| program.title.include?(NOTIFY_TITLE) }

    return if on_air_programs.empty?

    programs_by_title = on_air_programs.group_by { |program| [program.title, program.sub_title, program.st_time] }
    programs_by_title.values.each do |programs|
      ch_names = programs.sort_by(&:ch_id).map(&:ch_name)
      message = generate_message(programs.first, ch_names)

      post_message(message)
    end
  end

  private

    def current_programs
      current_time = Time.current
      min = current_time.min - (current_time.min % 10)
      start_at = current_time.change(min: min, sec: 0) + DELAY_MINUTES.minutes
      end_at = start_at + RANGE_MINUTES.minutes

      SyobocalUtils.programs(start_at, end_at)
    end

    def generate_message(program, ch_names)
      channel = ch_names.map { |ch_name| "【#{ch_name}】" }.join
      start_time = program.st_time.strftime("%H:%M")

      message = <<~MESSAGE
        #{channel}#{start_time}〜
        #{program.title}
      MESSAGE

      if program.story_number >= 1 || !program.sub_title.blank?
        line = []

        line << "第#{program.story_number}話" if program.story_number >= 1
        line << program.sub_title unless program.sub_title.blank?

        message << "#{line.join(" ")}\n"
      end

      message << "\nこのあとすぐ！\n"

      message.strip
    end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  OnAirBot.new.perform
end
