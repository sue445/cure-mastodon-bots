require_relative "./syobocal_ext"

module SyobocalUtils
  NOTIFY_TITLE = "プリキュア".freeze

  # Get programs from start_at to end_at
  #
  # @param start_at [Time]
  # @param end_at   [Time]
  # @param squeeze  [Boolean] Whether squueze with {NOTIFY_TITLE}
  #
  # @return [Array<Hashie::Mash>]
  def self.programs(start_at:, end_at:, squeeze: false)
    days = (end_at.to_date - start_at.to_date).to_i + 1
    prog_items = Syobocal::CalChk.get(start: start_at.to_date, days: days)

    prog_items.map! do |prog_item|
      # convert key: count -> story_number
      prog_item[:story_number] = prog_item.delete(:count)
      Hashie::Mash.new(prog_item)
    end

    prog_items.select! do |item|
      (start_at...end_at).cover?(item.st_time)
    end

    prog_items.select! { |program| program.title.include?(NOTIFY_TITLE) } if squeeze

    prog_items
  end

  # @param programs [Array<Hashie::Mash>]
  # @yieldparam program [Hashie::Mash]
  # @yieldparam ch_names [Array<String>]
  def self.each_with_same_story_number(programs)
    programs_by_title = programs.group_by { |program| [program.title, program.sub_title, program.st_time] }
    programs_by_title.values.each do |_programs|
      ch_names = _programs.sort_by(&:ch_id).map(&:ch_name)

      yield _programs.first, ch_names
    end
  end

  def self.format_program(program, ch_names = nil)
    ch_names = [program.ch_name] unless ch_names

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

    message
  end
end
