RSpec.describe Repper::Theme do
  describe '::cast' do
    it 'returns that Theme when given a Theme' do
      theme = Repper::Theme.new
      expect(Repper::Theme.cast(theme)).to equal theme
    end

    it 'returns that Theme when given the name of a known theme' do
      expect(Repper::Theme.cast(:default)).to equal Repper::Theme::Default
    end

    it 'returns a Theme when given a Hash' do
      expect(Repper::Theme.cast(foo: :bar)).to be_a Repper::Theme
    end

    it 'returns Theme::Plain when given nil or false' do
      expect(Repper::Theme.cast(nil)).to equal Repper::Theme::Plain
      expect(Repper::Theme.cast(false)).to equal Repper::Theme::Plain
    end

    it 'raises ArgumentError when given an unknown name' do
      expect { Repper::Theme.cast(:foo) }.to raise_error do |e|
         expect(e).to be_an(::ArgumentError).and be_a(Repper::ArgumentError)
      end
    end

    it 'raises ArgumentError when given any other Argument' do
      expect { Repper::Theme.cast(Object.new) }.to raise_error do |e|
        expect(e).to be_an(::ArgumentError).and be_a(Repper::ArgumentError)
      end
    end
  end
end
