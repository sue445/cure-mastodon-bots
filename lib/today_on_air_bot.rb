require_relative "./bot"
require_relative "./syobocal_utils"

class TodayOnAirBot < Bot
  def initialize
    super(ENV["MASTODON_URL"], ENV["ACCESS_TOKEN_ON_AIR"])
  end

  def perform
    on_air_programs = current_programs

    return if on_air_programs.empty?

    message = "今日のプリキュア"

    SyobocalUtils.each_with_same_story_number(on_air_programs) do |program, ch_names|
      message << "\n\n"
      message << generate_message(program, ch_names)
    end

    post_message(message)
  end

  private

    def current_programs
      current_time = Time.current

      start_at = current_time.beginning_of_day
      end_at = current_time.end_of_day

      SyobocalUtils.programs(start_at: start_at, end_at: end_at, squeeze: true)
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

      message.strip
    end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  TodayOnAirBot.new.perform
end
