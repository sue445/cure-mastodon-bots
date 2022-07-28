describe ProgramWithFormat do # rubocop:disable RSpec/FilePath
  describe Syobocalite::Program do
    describe "#format" do
      subject { program.format(ch_names) }

      let(:program) do
        Syobocalite::Program.new(
          pid:,
          tid:,
          st_time:      st_time.in_time_zone,
          ed_time:      ed_time.in_time_zone,
          ch_name:,
          ch_id:,
          count:,
          st_offset:,
          sub_title:,
          title:,
          prog_comment:,
        )
      end

      let(:pid)          { 0 }
      let(:tid)          { 0 }
      let(:st_time)      { "20170507083000" }
      let(:ed_time)      { "20170507083000" }
      let(:ch_name)      { "" }
      let(:ch_id)        { 0 }
      let(:count)        { 0 }
      let(:st_offset)    { 0 }
      let(:sub_title)    { "" }
      let(:title)        { "" }
      let(:prog_comment) { "" }

      context "has story_number and sub_title" do
        let(:pid)          { 409956 }
        let(:tid)          { 4461 }
        let(:st_time)      { "20170507083000" }
        let(:ed_time)      { "20170507083000" }
        let(:ch_name)      { "テレビ朝日" }
        let(:ch_id)        { 81 }
        let(:count)        { 14 }
        let(:st_offset)    { 0 }
        let(:sub_title)    { "お嬢さまロックンロール！" }
        let(:title)        { "キラキラ☆プリキュアアラモード" }
        let(:prog_comment) { "" }

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
        let(:pid)          { 428238 }
        let(:tid)          { 4747 }
        let(:st_time)      { "20171015133000" }
        let(:ed_time)      { "20171015145000" }
        let(:ch_name)      { "東映チャンネル" }
        let(:ch_id)        { 39 }
        let(:count)        { 0 }
        let(:st_offset)    { 0 }
        let(:sub_title)    { "" }
        let(:title)        { "映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！" }
        let(:prog_comment) { "" }

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
        let(:pid)          { 428238 }
        let(:tid)          { 4747 }
        let(:st_time)      { "20171015133000" }
        let(:ed_time)      { "20171015145000" }
        let(:ch_name)      { "東映チャンネル" }
        let(:ch_id)        { 39 }
        let(:count)        { 0 }
        let(:st_offset)    { 0 }
        let(:sub_title)    { "" }
        let(:title)        { "映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！" }
        let(:prog_comment) { "本編72分" }

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
end
