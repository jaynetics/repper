RSpec.describe Repper::Format::Structured do
  it 'renders the Regexp as a structure' do
    result = Repper.render(complex_regexp, format: :structured)
    expect(result).to have_color # due to default theme
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
        # comment
        \k<1>
      /x
    EOS
  end

  it 'represents literal n/r/t/v whitespace with escapes' do
    result = Repper.render(/#{"\n"}/, format: :structured)
    expect(result).to have_raw_text <<~'EOS'
      /
        \n
      /
    EOS
  end
end
