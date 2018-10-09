module ProgramWithFormat
  # rubocop:disable Metrics/AbcSize
  def format(ch_names = nil)
    ch_names = [ch_name] unless ch_names

    channel = ch_names.map {|ch_name| "【#{ch_name}】" }.join
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

Syobocalite::Program.class_eval do
  include ProgramWithFormat
end
