describe ProgramWithFormat do # rubocop:disable RSpec/FilePath
  describe Syobocalite::Program do
    describe "#format" do
      subject { program.format(ch_names) }

      let(:program) do
        Syobocalite::Program.new(attrs)
      end

      context "has story_number and sub_title" do
        let(:attrs) do
          {
            "PID"         => "409956",
            "TID"         => "4461",
            "StTime"      => "20170507083000",
            "EdTime"      => "20170507090000",
            "ChName"      => "テレビ朝日",
            "ChID"        => "81",
            "Count"       => "14",
            "StOffset"    => "0",
            "SubTitle"    => "お嬢さまロックンロール！",
            "Title"       => "キラキラ☆プリキュアアラモード",
            "ProgComment" => "",
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
            "PID"         => "428238",
            "TID"         => "4747",
            "StTime"      => "20171015133000",
            "EdTime"      => "20171015145000",
            "ChName"      => "東映チャンネル",
            "ChID"        => "39",
            "Count"       => "0",
            "StOffset"    => "0",
            "SubTitle"    => "",
            "Title"       => "映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！",
            "ProgComment" => "",
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
            "PID"         => "428238",
            "TID"         => "4747",
            "StTime"      => "20171015133000",
            "EdTime"      => "20171015145000",
            "ChName"      => "東映チャンネル",
            "ChID"        => "39",
            "Count"       => "0",
            "StOffset"    => "0",
            "SubTitle"    => "",
            "Title"       => "映画魔法つかいプリキュア！奇跡の変身！キュアモフルン！",
            "ProgComment" => "本編72分",
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
end
