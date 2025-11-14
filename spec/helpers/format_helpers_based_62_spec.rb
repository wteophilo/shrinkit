require "rails_helper"

RSpec.describe FormatHelpersBased62, type: :helper do
  BASE62_EXAMPLES = {
    0    => "0",
    1    => "1",
    10   => "A",
    61   => "z",
    62   => "10",
    100  => "1c",
    1000 => "G8",
    6199 => "1bz",
    6200 => "1c0",
    1000000 => "4C92",
    123456789 => "8M0kX"
  }.freeze

  describe "#formatted_based_62" do
    context "when give standard integer inputs" do
      BASE62_EXAMPLES.each do |input, expected_output|
        it "encodes the number #{input} correctly to #{expected_output}" do
          expect(helper.formatted_based_62(input)).to eq(expected_output)
        end
      end
    end

    context "when given edge case inputs" do
      it "handles the number 0 (zero)" do
        expect(formatted_based_62(0)).to eq("0")
      end

      it "handles numbers equal to the base (62) and its power (3844)" do
        expect(formatted_based_62(62)).to eq("10")
        expect(formatted_based_62(3844)).to eq("100") # 62 * 62
      end

      it "handles a very large number" do
        large_number = 999999999999
        expected = "HbXm5a3"
        expect(formatted_based_62(large_number)).to eq(expected)
      end
    end

    context 'when input is not an integer' do
      it 'raises an error when given a string' do
        expect { formatted_based_62("abc") }.to raise_error(NoMethodError)
      end
    end
  end
end
