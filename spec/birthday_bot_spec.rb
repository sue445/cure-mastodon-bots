describe BirthdayBot do
  let(:bot) { BirthdayBot.new }

  describe "#perform" do
    context "When birthday of someone" do
      before do
        Timecop.freeze("2016-06-12".in_time_zone)
      end

      it "posts tweet" do
        allow(bot).to receive(:post_message)
        bot.perform
        expect(bot).to have_received(:post_message).with("今日はキュアミラクル（Cv. 高橋李依）の誕生日です！")
      end
    end

    context "When birthday of nobody" do
      before do
        Timecop.freeze("2016-01-01".in_time_zone)
      end

      it "does not post tweet" do
        allow(bot).to receive(:post_message)
        bot.perform
        expect(bot).not_to have_received(:post_message)
      end
    end
  end
end
