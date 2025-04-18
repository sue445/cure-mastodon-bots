require_relative "syobocalite_ext"

class ProgramManager
  NOTIFY_TITLES = %w[プリキュア ぷりきゅあ].freeze

  # Get programs from start_at to end_at
  #
  # @param start_at [Time]
  # @param end_at   [Time]
  # @param squeeze  [Boolean] Whether squeeze with プリキュア or ぷりきゅあ
  #
  # @return [Array<Syobocalite::Program>]
  def self.search(start_at:, end_at:, squeeze: false)
    programs = Syobocalite.search(start_at:, end_at:)

    programs.select! {|program| NOTIFY_TITLES.any? {|title| program.title.include?(title) } } if squeeze

    programs
  end

  # @param programs [Array<Syobocalite::Program>]
  # @yieldparam program [Syobocalite::Program]
  # @yieldparam ch_names [Array<String>]
  def self.each_with_same_story_number(programs)
    programs_by_title = programs.group_by {|program| [program.title, program.sub_title, program.st_time] }
    programs_by_title.each_value do |_programs|
      ch_names = _programs.sort_by(&:ch_id).map(&:ch_name)

      yield _programs.first, ch_names
    end
  end
end
