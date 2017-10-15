require_relative "./syobocal_ext"

module SyobocalUtils
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
end
