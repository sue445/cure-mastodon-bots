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
      Timecop.freeze("2017-10-15 08:30:00".in_time_zone)

      stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=#{days}&start=2017-10-14").
        to_return(status: 200, body: read_stub("cal_chk_20171014-20171015.xml"))
    end

    let(:days) { 2 + App::PROGRAM_WEEKS * 7 }

    it { should be_ok }
    its(:errors) { should eq "" }
  end
end
