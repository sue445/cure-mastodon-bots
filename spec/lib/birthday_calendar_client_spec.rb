RSpec.describe BirthdayCalendarClient do
  let(:client) { BirthdayCalendarClient.new }

  describe "#find_by_birthday" do
    subject { client.find_by_birthday(date) }

    include_context :setup_birthday_calendar_stub

    context "exists birthday" do
      let(:date) { Date.parse("2021-08-08") }

      it { should eq %w(キュアバタフライ(聖あげは)) }
    end

    context "not exists birthday" do
      let(:date) { Date.parse("2021-08-10") }

      it { should eq [] }
    end
  end
end
