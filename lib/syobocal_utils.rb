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
end
