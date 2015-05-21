describe MightyStruct do
  let(:hash) do
    {
      a: "a",
      b: [
        1,
        {
          "d" => "d"
        },
        [
          {
            e: "e"
          }
        ]
      ],
      "c" => {
        f: "f"
      }
    }
  end

  describe ".new" do
    context "if called with an array or a hash" do
      it "returns an instance of #{described_class}" do
        expect(described_class.new([])).to be_a(described_class)
        expect(described_class.new({})).to be_a(described_class)
      end

      #
      # caching
      #
      context "if called with caching: :disabled" do
        subject { described_class.new(hash, caching: :disabled) }

        it "does not cache accessor results" do
          expect(subject.a).to eq(hash[:a])
          hash[:a] = new_value = "new_value"
          expect(subject.a).to eq(new_value)
        end
      end

      context "if called with caching: :enabled" do
        subject { described_class.new(hash, caching: :enabled) }

        it "caches accessor results" do
          expect(subject.a).to eq(hash[:a])
          old_value = hash[:a]
          hash[:a] = "new_value"
          expect(subject.a).to eq(old_value)
        end
      end

      context "if called with caching: :smart" do
        subject { described_class.new(hash, caching: :smart) }

        it "does cache accessor results, but invalidates the cache on method_missing" do
          expect(subject.a).to eq(hash[:a])
          subject[:a] = new_value = "new_value"
          expect(subject.a).to eq(new_value)
        end
      end
    end

    context "if called with something not an array or a hash" do
      it "raises an ArgumentError" do
        expect { described_class.new("foo") }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".to_object" do
    context "if given an instance of #{described_class}" do
      it "returns the wrapped object" do
        expect(described_class.to_object(described_class.new(hash))).to eql(hash)
      end
    end

    context "if given anything that is not an instance of #{described_class}" do
      it "returns the given object" do
        expect(described_class.to_object(hash)).to eql(hash)
      end
    end
  end

  context "if initialzed with an Enumerable" do
    subject(:mighty_struct) { described_class.new(hash) }

    # in contract to "it responds to" this ensures that there are real methods
    it "has method accessors for each property" do
      expect(hash.keys.all? { |_key| subject.public_methods.include?(_key.to_sym) }).to be_truthy
    end

    it "allows deep method access of properties" do
      expect(subject.c.f).to eq(hash["c"][:f])
    end

    it "dispatches non accessor methods to the wrapped object" do
      expect(subject.size).to eq(hash.size)
      expect { subject.foo }.to raise_error(NoMethodError)
    end
  end
end
