RSpec.describe ATProto::TID do
  it "produces a valid TID given a timestamp" do
    tid = ATProto::TID.new(Time.at(1696461232))
    expect(tid.to_s).to eq("3kaxkolrn22ab")
  end
  describe "::from_string" do
    it "can convert a TID string to its valid timestamp" do
      tid = ATProto::TID.from_string("3kaxkolrn22ab")
      time = Time.at(1696461232)
      expect(tid.to_time).to eq(time)
    end
    it "raises an exception if the TID is invalid" do
      expect { ATProto::TID.from_string("invalid") }.to raise_error(ArgumentError)
    end
  end
end
