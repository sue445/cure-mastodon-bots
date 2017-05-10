describe OnAirBot do
  let(:bot) { OnAirBot.new }

  before do
    stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=1&start=2017-05-07").
      to_return(status: 200, body: read_stub("cal_chk_20170507.xml"))
  end

  describe "#perform" do
    subject { bot.perform }

    before do
      Timecop.freeze("2017-05-07 08:21:30".in_time_zone)
    end

    let(:expected_message) do
      <<~EOS
        【テレビ朝日】【ABCテレビ】【メ～テレ】08:30〜
        キラキラ☆プリキュアアラモード
        第14話 お嬢さまロックンロール！

        このあとすぐ！
      EOS
    end

    it "posts message" do
      allow(bot).to receive(:post_message)
      bot.perform

      expect(bot).to have_received(:post_message).with(expected_message.strip)
    end
  end

  describe ".programs" do
    subject { OnAirBot.programs(start_at, end_at) }

    let(:start_at) { Time.zone.parse("2017-05-07 08:30:00") }
    let(:end_at)   { Time.zone.parse("2017-05-07 09:00:00") }

    its(:count) { should eq 7 }
    its([4]) { should include(ch_id: 6, ch_name: "テレビ朝日", title: "キラキラ☆プリキュアアラモード", sub_title: "お嬢さまロックンロール！", count: 14) }
  end
end
