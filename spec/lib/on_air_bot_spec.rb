describe OnAirBot do
  let(:bot) { OnAirBot.new }

  describe "#perform" do
    subject { bot.perform }

    context "has story_number and sub_title" do
      before do
        stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=1&start=2017-05-07").
          to_return(status: 200, body: read_stub("cal_chk_20170507.xml"))

        Timecop.freeze("2017-05-07 08:21:30".in_time_zone)
      end

      let(:expected_message) do
        <<~MESSAGE
          【テレビ朝日】【ABCテレビ】【メ～テレ】08:30〜
          キラキラ☆プリキュアアラモード
          第14話 お嬢さまロックンロール！

          このあとすぐ！
        MESSAGE
      end

      it "posts message" do
        allow(bot).to receive(:post_message)
        bot.perform

        expect(bot).to have_received(:post_message).with(expected_message.strip)
      end
    end

    context "no story_number and sub_title" do
      before do
        stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=1&start=2017-10-15").
          to_return(status: 200, body: read_stub("cal_chk_20171015.xml"))

        Timecop.freeze("2017-10-15 13:21:30".in_time_zone)
      end

      let(:expected_message) do
        <<~MESSAGE
          【東映チャンネル】13:30〜
          映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！

          このあとすぐ！
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
