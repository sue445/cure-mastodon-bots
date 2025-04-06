shared_context :setup_birthday_calendar_stub do
  before do
    BirthdayCalendarClient::ALL_SERIES.each do |series|
      stub_request(:get, "https://raw.githubusercontent.com/sue445/pretty-all-friends-birthday-calendar/master/config/#{series}.yml").
        to_return(status: 200, body: fixture("#{series}.yml"))
    end
  end
end
