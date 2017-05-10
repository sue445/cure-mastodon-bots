describe App do
  include Rack::Test::Methods

  def app
    App
  end

  describe "GET /" do
    subject do
      get "/"
      last_response
    end

    before do
      Timecop.freeze("2017-05-07 08:30:00".in_time_zone)

      stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=#{days}&start=2017-05-07").
        to_return(status: 200, body: read_stub("cal_chk_20170507.xml"))
    end

    let(:days){ 1 + App::PROGRAM_WEEKS.weeks }

    it { should be_ok }
  end
end
