RSpec.describe Repper::Format do
  describe '::cast' do
    it 'returns that Proc when given a Proc' do
      proc = ->{}
      expect(Repper::Format.cast(proc)).to equal proc
    end

    it 'returns that Format when given the name of a known format' do
      expect(Repper::Format.cast(:inline)).to equal Repper::Format::Inline
    end

    it 'returns Format::Plain when given nil or false' do
      expect(Repper::Format.cast(nil)).to equal Repper::Format::Plain
      expect(Repper::Format.cast(false)).to equal Repper::Format::Plain
    end

    it 'raises ArgumentError when given an unknown name' do
      expect { Repper::Format.cast(:foo) }.to raise_error do |e|
        expect(e).to be_an(::ArgumentError).and be_a(Repper::ArgumentError)
      end
    end

    it 'raises ArgumentError when given any other Argument' do
      expect { Repper::Format.cast(Object.new) }.to raise_error do |e|
        expect(e).to be_an(::ArgumentError).and be_a(Repper::ArgumentError)
      end
    end
  end
end
