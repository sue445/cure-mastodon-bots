RSpec.describe BirthdayCalendarClient do
  let(:client) { BirthdayCalendarClient.new }

  describe "#all_characters" do
    subject { client.all_characters }

    include_context :setup_birthday_calendar_stub

    its(:count) { should eq 92 }
  end

  describe "#find_by_birthday" do
    subject { client.find_by_birthday(date) }

    include_context :setup_birthday_calendar_stub

    context "exists birthday" do
      let(:date) { Date.parse("2021-08-08") }

      it { should eq %w(メルパン 上葉みあ 陽比野まつり 黒川冷) }
    end

    context "not exists birthday" do
      let(:date) { Date.parse("2021-08-10") }

      it { should eq [] }
    end

    context "exists birthday (aipri)" do
      let(:date) { Date.parse("2024-08-18") }

      it { should eq %w(夢川ゆい 青空ひまり) }
    end
  end
end
