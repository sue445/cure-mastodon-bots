require_relative "./syobocal_ext"

class Program
  NOTIFY_TITLE = "プリキュア".freeze

  attr_accessor :pid, :tid, :st_time, :ed_time, :ch_name, :ch_id, :story_number, :st_offset, :sub_title, :title, :prog_comment

  def initialize(attrs = {})
    @pid          = attrs[:pid]
    @tid          = attrs[:tid]
    @st_time      = attrs[:st_time]
    @ed_time      = attrs[:ed_time]
    @ch_name      = attrs[:ch_name]
    @ch_id        = attrs[:ch_id]
    @story_number = attrs[:count]
    @st_offset    = attrs[:st_offset]
    @sub_title    = attrs[:sub_title]
    @title        = attrs[:title]
    @prog_comment = attrs[:prog_comment]&.gsub(/^!/, "")
  end

  # Get programs from start_at to end_at
  #
  # @param start_at [Time]
  # @param end_at   [Time]
  # @param squeeze  [Boolean] Whether squeeze with {NOTIFY_TITLE}
  #
  # @return [Array<Program>]
  def self.search(start_at:, end_at:, squeeze: false)
    days = (end_at.to_date - start_at.to_date).to_i + 1
    prog_items = Syobocal::CalChk.get(start: start_at.to_date, days: days)

    programs = prog_items.map { |prog_item| Program.new(prog_item) }

    programs.select! do |item|
      (start_at...end_at).cover?(item.st_time)
    end

    programs.select! { |program| program.title.include?(NOTIFY_TITLE) } if squeeze

    programs
  end

  # @param programs [Array<Hashie::Mash>]
  # @yieldparam program [Program]
  # @yieldparam ch_names [Array<String>]
  def self.each_with_same_story_number(programs)
    programs_by_title = programs.group_by { |program| [program.title, program.sub_title, program.st_time] }
    programs_by_title.values.each do |_programs|
      ch_names = _programs.sort_by(&:ch_id).map(&:ch_name)

      yield _programs.first, ch_names
    end
  end

  # rubocop:disable Metrics/AbcSize
  def format(ch_names = nil)
    ch_names = [ch_name] unless ch_names

    channel = ch_names.map { |ch_name| "【#{ch_name}】" }.join
    start_time = st_time.strftime("%H:%M")

    message = <<~MESSAGE
      #{channel}#{start_time}〜
      #{title}
    MESSAGE

    if story_number >= 1 || !sub_title.blank?
      line = []

      line << "第#{story_number}話" if story_number >= 1
      line << sub_title unless sub_title.blank?

      message << "#{line.join(" ")}\n"
    end

    unless prog_comment.blank?
      message << "※#{prog_comment}\n"
    end

    message
  end
  # rubocop:enable Metrics/AbcSize
end
