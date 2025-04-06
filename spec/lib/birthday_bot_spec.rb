describe BirthdayBot do
  describe ".generate_message" do
    subject { BirthdayBot.generate_message(date) }

    include_context :setup_birthday_calendar_stub

    context "When birthday of 1 person" do
      let(:date) { Date.parse("2016-06-12") }

      it { should eq "今日はキュアミラクル(朝日奈みらい)の誕生日です！ https://sue445.github.io/precure-birthday-calendar/" }
    end

    context "When birthday of multiple persons" do
      let(:date) { Date.parse("2025-04-12") }

      it { should eq "今日はキュアスター(星奈ひかる)、パムパムの誕生日です！ https://sue445.github.io/precure-birthday-calendar/" }
    end

    context "When birthday of nobody" do
      let(:date) { Date.parse("2016-01-01") }

      it { should eq nil }
    end
  end
end
