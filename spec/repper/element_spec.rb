RSpec.describe Repper::Element do
  describe '#annotation' do
    it 'is present for all type/token combinations of regexp_parser' do
      Regexp::Syntax::Token::Map.each do |type, tokens|
        tokens.each do |token|
          element = Repper::Element.new(type: type, subtype: token)
          expect(element.annotation).to match /\S/
        end
      end
    end
  end
end
