module ForceTimeWithZone
  refine(Time) do
    def parse(*args)
      puts "called Time.zone.parse" # TODO: remove after
      Time.zone.parse(*args)
    end
  end
end

require "syobocal"

# module Syobocal::CalChk
#   class << self
#     using ForceTimeWithZone
#   end
# end

# Syobocal::CalChk.class_eval do
#   using ForceTimeWithZone
# end

# Syobocal::CalChk.singleton_class.class_eval do
#   using ForceTimeWithZone
# end

Syobocal::CalChk.singleton_class.instance_eval do
  using ForceTimeWithZone
end
