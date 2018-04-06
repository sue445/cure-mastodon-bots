describe TodayOnAirBot do
  let(:bot) { TodayOnAirBot.new }

  describe "#perform" do
    subject { bot.perform }

    context "when daytime programs" do
      before do
        stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=2&start=2017-10-14").
          to_return(status: 200, body: read_stub("cal_chk_20171014-20171015.xml"))

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
          ※本編72分
        MESSAGE
      end

      it "posts message" do
        allow(bot).to receive(:post_message)
        bot.perform

        expect(bot).to have_received(:post_message).with(expected_message.strip)
      end
    end

    context "when midnight programs" do
      before do
        stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=2&start=2018-04-06").
          to_return(status: 200, body: read_stub("cal_chk_20180406-20180407.xml"))

        Timecop.freeze("2018-04-07 00:00:30".in_time_zone)
      end

      let(:expected_message) do
        <<~MESSAGE
          今日のプリキュア

          【キッズステーション】03:00〜
          ふたりはプリキュア
          第8話 プリキュア解散！ぶっちゃけ早すぎ!?
        MESSAGE
      end

      it "posts message" do
        allow(bot).to receive(:post_message)
        bot.perform

        expect(bot).to have_received(:post_message).with(expected_message.strip)
      end
    end
  end
end
