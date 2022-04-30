RSpec.describe Repper do
  it 'has a version number' do
    expect(Repper::VERSION).not_to be nil
  end

  let(:complex_regexp) do
    /
      foo+?
      \K
      (?=bar)
      [\p{ascii}&&\x42-\u1234[^a-z]]
      ( qux (?:baz|bla) )
      (?(1)foo|bar)
      (?i)
      (?~baz)
      (?m-i:.\X\t\b) # comment
      \k<1>
    /x
  end

  describe '::render' do
    describe 'with format: :plain' do
      it 'simply re-renders the original Regexp' do
        result = Repper.render(complex_regexp, format: :plain)
        expect(result).to eq "/#{complex_regexp.source}/x"
      end
    end

    describe 'with format: :inline' do
      it 'renders the original Regexp, but with theme colors' do
        result = Repper.render(complex_regexp, format: :inline)
        expect(result).to have_color
        expect(result).to have_raw_text "/#{complex_regexp.source}/x"
      end
    end

    describe 'with format: :structured' do
      it 'renders the Regexp as a structure' do
        result = Repper.render(complex_regexp, format: :structured)
        expect(result).to have_color
        expect(result).to have_raw_text <<~'EOS'
          /
            fo
            o
            +?
            \K
            (?=
              bar
            )
            [
                \p{ascii}
              &&
                  \x42
                -
                  \u1234
                [^
                    a
                  -
                    z
                ]
            ]
            (
              qux
              (?:
                  baz
                |
                  bla
              )
            )
            (?
              (1)
              foo
            |
              bar
            )
            (?i
            )
            (?~
              baz
            )
            (?m-i:
              .
              \X
              \t
              \b
            )
            # comment\n
            \k<1>
          /x
        EOS
      end
    end

    describe 'with format: :annotated' do
      it 'renders the Regexp as an annotated structure' do
        result = Repper.render(complex_regexp, format: :annotated)
        expect(result).to have_color
        expect(result).to have_raw_text(<<~'EOS')
          /
            fo             literal
            o              literal
            +?             one or more quantifier
            \K             keep-mark lookbehind
            (?=            lookahead assertion
              bar          literal
            )              lookahead assertion
            [              character set
                \p{ascii}  ascii property
              &&           intersection
                  \x42     hex escape
                -          range
                  \u1234   codepoint escape
                [^         character set
                    a      literal
                  -        range
                    z      literal
                ]          character set
            ]              character set
            (              capture group 1
              qux          literal
              (?:          passive group
                  baz      literal
                |          alternation
                  bla      literal
              )            passive group
            )              capture group 1
            (?             conditional
              (1)          condition
              foo          literal
            |              conditional
              bar          literal
            )              conditional
            (?i            options switch group
            )              options switch group
            (?~            absence group
              baz          literal
            )              absence group
            (?m-i:         options group
              .            match-all
              \X           xgrapheme type
              \t           tab escape
              \b           word boundary anchor
            )              options group
            # comment\n    comment
            \k<1>          number ref backref
          /x
        EOS
      end
    end

    describe 'with theme: :plain' do
      it 'renders without colors' do
        result = Repper.render(complex_regexp, format: :inline, theme: :plain)
        expect(result).not_to have_color
        expect(result).to eq "/#{complex_regexp.source}/x"
      end
    end

    describe 'with theme: nil' do
      it 'renders without colors' do
        result = Repper.render(complex_regexp, format: :inline, theme: nil)
        expect(result).not_to have_color
        expect(result).to eq "/#{complex_regexp.source}/x"
      end
    end
  end
end
