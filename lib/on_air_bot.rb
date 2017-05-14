require_relative "./bot"
require_relative "./syobocal_ext"

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

  # @param start_at [Time]
  # @param end_at   [Time]
  def self.programs(start_at, end_at)
    days = (end_at.to_date - start_at.to_date).to_i + 1
    prog_items = Syobocal::CalChk.get(start: start_at.to_date, days: days)
    prog_items = prog_items.map do |prog_item|
      # convert key: count -> story_number
      prog_item[:story_number] = prog_item.delete(:count)
      Hashie::Mash.new(prog_item)
    end
    prog_items.select do |item|
      (start_at...end_at).cover?(item.st_time)
    end
  end

  private

    def current_programs
      current_time = Time.current
      min = current_time.min - (current_time.min % 10)
      start_at = current_time.change(min: min, sec: 0) + DELAY_MINUTES.minutes
      end_at = start_at + RANGE_MINUTES.minutes

      OnAirBot.programs(start_at, end_at)
    end

    def generate_message(program, ch_names)
      channel = ch_names.map { |ch_name| "【#{ch_name}】" }.join
      start_time = program.st_time.strftime("%H:%M")

      message = <<~EOS
        #{channel}#{start_time}〜
        #{program.title}
        第#{program.story_number}話 #{program.sub_title}

        このあとすぐ！
      EOS

      message.strip
    end
end

if $PROGRAM_NAME == __FILE__
  Bundler.require(:default, :development)

  Dotenv.load
  OnAirBot.new.perform
end
