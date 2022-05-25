RSpec.describe Repper::Token do
  describe '#annotation' do
    it 'is present for all type/token combinations of regexp_parser' do
      Regexp::Syntax::Token::Map.each do |type, tokens|
        tokens.each do |token|
          token = Repper::Token.new(type: type, subtype: token)
          expect(token.annotation).to match /\S/
        end
      end
    end
  end
end
