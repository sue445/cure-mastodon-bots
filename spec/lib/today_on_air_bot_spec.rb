describe TodayOnAirBot do
  let(:bot) { TodayOnAirBot.new }

  describe "#perform" do
    subject { bot.perform }

    before do
      stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=1&start=2017-10-15").
        to_return(status: 200, body: read_stub("cal_chk_20171015.xml"))

      Timecop.freeze("2017-10-15 00:00:30".in_time_zone)
    end

    let(:expected_message) do
      <<~MESSAGE
        今日のプリキュア

        【テレビ朝日】【ABCテレビ】【メ～テレ】08:30〜
        キラキラ☆プリキュアアラモード
        第36話 いちかとあきら！いちご坂大運動会！

        【東映チャンネル】13:30〜
        映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！
      MESSAGE
    end

    it "posts message" do
      allow(bot).to receive(:post_message)
      bot.perform

      expect(bot).to have_received(:post_message).with(expected_message.strip)
    end
  end
end
