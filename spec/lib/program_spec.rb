describe Program do
  describe ".search" do
    subject(:programs) { Program.search(start_at: start_at, end_at: end_at, squeeze: squeeze) }

    before do
      stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=2&start=2017-05-06").
        to_return(status: 200, body: read_stub("cal_chk_20170506-20170507.xml"))
    end

    let(:start_at) { Time.zone.parse("2017-05-07 08:30:00") }
    let(:end_at)   { Time.zone.parse("2017-05-07 09:00:00") }

    context "squeeze is true" do
      let(:squeeze) { true }

      its(:count) { should eq 3 }

      it "title all include '#{Program::NOTIFY_TITLE}'" do
        titles = subject.map(&:title)
        expect(titles).to all(include(Program::NOTIFY_TITLE))
      end

      describe "[0]" do
        subject { programs[0] }

        its(:ch_id)        { should eq 6 }
        its(:ch_name)      { should eq "テレビ朝日" }
        its(:title)        { should eq "キラキラ☆プリキュアアラモード" }
        its(:sub_title)    { should eq "お嬢さまロックンロール！" }
        its(:story_number) { should eq 14 }
        its(:st_time)      { should eq "2017-05-07 08:30:00".in_time_zone }
        its(:st_time)      { should be_instance_of ActiveSupport::TimeWithZone }
        its(:ed_time)      { should eq "2017-05-07 09:00:00".in_time_zone }
        its(:ed_time)      { should be_instance_of ActiveSupport::TimeWithZone }
      end
    end

    context "squeeze is false" do
      let(:squeeze) { false }

      its(:count) { should eq 7 }

      describe "[4]" do
        subject { programs[4] }

        its(:ch_id)        { should eq 6 }
        its(:ch_name)      { should eq "テレビ朝日" }
        its(:title)        { should eq "キラキラ☆プリキュアアラモード" }
        its(:sub_title)    { should eq "お嬢さまロックンロール！" }
        its(:story_number) { should eq 14 }
        its(:st_time)      { should eq "2017-05-07 08:30:00".in_time_zone }
        its(:st_time)      { should be_instance_of ActiveSupport::TimeWithZone }
        its(:ed_time)      { should eq "2017-05-07 09:00:00".in_time_zone }
        its(:ed_time)      { should be_instance_of ActiveSupport::TimeWithZone }
      end
    end

    context "contains html entity" do
      before do
        stub_request(:get, "http://cal.syoboi.jp/cal_chk.php?days=2&start=2018-05-01").
          to_return(status: 200, body: read_stub("cal_chk_20180501-20180502.xml"))
      end

      let(:start_at) { Time.zone.parse("2018-05-02 19:30:00") }
      let(:end_at)   { Time.zone.parse("2018-05-02 20:00:00") }
      let(:squeeze)  { true }

      describe "[0]" do
        subject { programs[0] }

        its(:ch_id)        { should eq 19 }
        its(:ch_name)      { should eq "TOKYO MX" }
        its(:title)        { should eq "魔法つかいプリキュア！" }
        its(:sub_title)    { should eq "Let'sエンジョイ！魔法学校の夏休み！" }
        its(:story_number) { should eq 27 }
        its(:st_time)      { should eq "2018-05-02 19:30:00".in_time_zone }
        its(:st_time)      { should be_instance_of ActiveSupport::TimeWithZone }
        its(:ed_time)      { should eq "2018-05-02 20:00:00".in_time_zone }
        its(:ed_time)      { should be_instance_of ActiveSupport::TimeWithZone }
      end
    end
  end

  describe "#format" do
    subject { program.format(ch_names) }

    let(:program) do
      Program.new(attrs)
    end

    context "has story_number and sub_title" do
      let(:attrs) do
        {
          pid: 409956,
          tid: 4461,
          st_time: Time.zone.parse("20170507083000"),
          ed_time: Time.zone.parse("20170507090000"),
          ch_name: "テレビ朝日",
          ch_id: 81,
          count: 14,
          st_offset: 0,
          sub_title: "お嬢さまロックンロール！",
          title: "キラキラ☆プリキュアアラモード",
          prog_comment: "",
        }
      end

      let(:ch_names) { %w[テレビ朝日 ABCテレビ メ～テレ] }

      let(:expected_message) do
        <<~MESSAGE
          【テレビ朝日】【ABCテレビ】【メ～テレ】08:30〜
          キラキラ☆プリキュアアラモード
          第14話 お嬢さまロックンロール！
        MESSAGE
      end

      it { should eq expected_message }
    end

    context "no story_number and sub_title" do
      let(:attrs) do
        {
          pid: 428238,
          tid: 4747,
          st_time: Time.zone.parse("20171015133000"),
          ed_time: Time.zone.parse("20171015145000"),
          ch_name: "東映チャンネル",
          ch_id: 39,
          count: 0,
          st_offset: 0,
          sub_title: "",
          title: "映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！",
          prog_comment: "",
        }
      end

      let(:ch_names) { %w[東映チャンネル] }

      let(:expected_message) do
        <<~MESSAGE
          【東映チャンネル】13:30〜
          映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！
        MESSAGE
      end

      it { should eq expected_message }
    end

    context "has prog_comment" do
      let(:attrs) do
        {
          pid: 428238,
          tid: 4747,
          st_time: Time.zone.parse("20171015133000"),
          ed_time: Time.zone.parse("20171015145000"),
          ch_name: "東映チャンネル",
          ch_id: 39,
          count: 0,
          st_offset: 0,
          sub_title: "",
          title: "映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！",
          prog_comment: "本編72分",
        }
      end

      let(:ch_names) { %w[東映チャンネル] }

      let(:expected_message) do
        <<~MESSAGE
          【東映チャンネル】13:30〜
          映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！
          ※本編72分
        MESSAGE
      end

      it { should eq expected_message }
    end
  end
end
