RSpec.describe Repper::Format::Annotated do
  it 'is the default' do
    expect(Repper.render(basic_regexp))
      .to eq(Repper.render(basic_regexp, format: :annotated))
  end

  it 'renders the Regexp as an annotated structure' do
    result = Repper.render(complex_regexp, format: :annotated)
    expect(result).to have_color # due to default theme
    expect(result).to have_raw_text(<<~'EOS')
      /
        fo             literal
        o              literal
        +?             one or more quantifier
        \K             keep-mark lookbehind
        (?=            lookahead
          bar          literal
        )              lookahead
        [              character set
            \p{ascii}  ascii property
          &&           intersection
              \x42     hex escape
            -          character range
              \u1234   codepoint escape
            [^         character set
                a      literal
              -        character range
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
          \b           word boundary
        )              options group
        # comment      comment
        \k<1>          backreference
      /x
    EOS
  end
end
