require "open-uri"
require "yaml"

class BirthdayCalendarClient
  ALL_SERIES = %w(king_of_prism pretty_rhythm prichan pripara primagi aipri)

  # @return [Array<Hash>]
  def all_characters
    ALL_SERIES.each_with_object([]) do |series, characters|
      hash = fetch_config(series)
      characters.push(*hash["characters"])
    end
  end

  # @param date [Date]
  # @return [Array<String>]
  def find_by_birthday(date)
    characters =
      all_characters.select do |character|
        month, day = *character["birthday"].split("/")
        month.to_i == date.month && day.to_i == date.day
      end

    characters.map { |character| character["name"] }.sort_by(&:itself)
  end

  private

  # @param series [String]
  # @return [Hash]
  # @see https://github.com/sue445/pretty-all-friends-birthday-calendar/tree/master/config
  def fetch_config(series)
    content = URI.parse("https://raw.githubusercontent.com/sue445/pretty-all-friends-birthday-calendar/master/config/#{series}.yml").read
    YAML.load(content)
  end
end
