describe OnAirBot do
  let(:bot) { OnAirBot.new }

  describe "#perform" do
  end

  describe ".programs" do
    subject { OnAirBot.programs(start_at, end_at) }

    before do
      stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=1&start=2017-05-07").
        to_return(status: 200, body: read_stub("cal_chk_20170507.xml"))
    end

    let(:start_at) { Time.zone.parse("2017-05-07 08:30:00") }
    let(:end_at)   { Time.zone.parse("2017-05-07 09:00:00") }

    its(:count) { should eq 7 }
    its([4]) { should include(ch_id: 6, ch_name: "テレビ朝日", title: "キラキラ☆プリキュアアラモード", sub_title: "お嬢さまロックンロール！", count: 14) }
  end
end
