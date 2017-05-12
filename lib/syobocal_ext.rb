# rubocop:disable all This is monkey patch!

module ParseWithTimeWithZone
  def parse(xml)
    xml = REXML::Document.new(xml)

    result = Syobocal::CalChk::Result.new

    syobocal = xml.elements['syobocal']
    result.url = syobocal.attribute("url").to_s
    result.version = syobocal.attribute("version").to_s
    result.last_update = Time.parse(syobocal.attribute("LastUpdate").to_s)
    result.spid = syobocal.attribute("SPID").to_s
    result.spname = syobocal.attribute("SPNAME").to_s

    xml.elements.each('syobocal/ProgItems/ProgItem'){|item|
      result << {
        :pid => item.attribute("PID").to_s.to_i,
        :tid => item.attribute("TID").to_s.to_i,
        :st_time => Time.zone.parse(item.attribute("StTime").to_s), # monkey patched
        :ed_time => Time.zone.parse(item.attribute("EdTime").to_s), # monkey patched
        :ch_name => item.attribute("ChName").to_s,
        :ch_id => item.attribute("ChID").to_s.to_i,
        :count => item.attribute("Count").to_s.to_i,
        :st_offset => item.attribute("StOffset").to_s.to_i,
        :sub_title => item.attribute("SubTitle").to_s,
        :title => item.attribute("Title").to_s,
        :prog_comment => item.attribute("ProgComment").to_s
      }
    }

    result
  end
end

Syobocal::CalChk.singleton_class.send(:prepend, ParseWithTimeWithZone)
