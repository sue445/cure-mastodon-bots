describe ProgramManager do
  describe ".search" do
    subject(:programs) { ProgramManager.search(start_at:, end_at:, squeeze:) }

    before do
      stub_request(:get, "https://cal.syoboi.jp/cal_chk.php?days=1&start=2017-05-07").
        to_return(status: 200, body: read_stub("cal_chk_20170507.xml"))
    end

    let(:start_at) { Time.zone.parse("2017-05-07 08:30:00") }
    let(:end_at)   { Time.zone.parse("2017-05-07 09:00:00") }

    context "squeeze is true" do
      let(:squeeze) { true }

      its(:count) { should eq 3 }

      it "title all include 'プリキュア' or 'ぷりきゅあ'" do
        titles = subject.map(&:title)
        expect(titles).to all(include("プリキュア").or(include("ぷりきゅあ")))
      end

      describe "[0]" do
        subject { programs[0] }

        its(:ch_id)        { should eq 6 }
        its(:ch_name)      { should eq "テレビ朝日" }
        its(:title)        { should eq "キラキラ☆プリキュアアラモード" }
        its(:sub_title)    { should eq "お嬢さまロックンロール！" }
        its(:story_number) { should eq 14 }
        its(:st_time)      { should eq "2017-05-07 08:30:00".in_time_zone }
        its(:ed_time)      { should eq "2017-05-07 09:00:00".in_time_zone }
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
        its(:ed_time)      { should eq "2017-05-07 09:00:00".in_time_zone }
      end
    end
  end
end
