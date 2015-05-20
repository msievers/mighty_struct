describe MightyStruct do
  let(:hash) do
    {
      a: 1,
      b: [1,2],
      "c" => {
        dasdsadsada: 1
      }
    }
  end

  describe "#new" do
    context "if called with an array or a hash" do
      it "returns an instance of #{described_class}" do
        expect(described_class.new([])).to be_a(described_class)
        expect(described_class.new({})).to be_a(described_class)
      end
    end

    context "if called with something not an array or a hash" do
      it "raises an ArgumentError" do
        expect { described_class.new("foo") }.to raise_error(ArgumentError)
      end
    end
  end

  context "if initialzed with a hash" do
    subject(:mighty_struct) { described_class.new(hash) }

    # in contract to "it responds to" this ensures that there are real methods
    it "has method accessors for each property" do
      expect(hash.keys.all? { |_key| subject.public_methods.include?(_key.to_sym) }).to be_truthy
    end
  end
end
