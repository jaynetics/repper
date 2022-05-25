RSpec.describe Repper::Format::Extended do
  it 'renders the Regexp as a structured, machine-readable, x-mode Regexp' do
    # it is rendered with color by default
    result = Repper.render(complex_regexp, format: :extended)
    expect(result).to have_color
    expect(raw_text(result)).to be_functionally_equivalent_to(complex_regexp)
    expect(result).to have_raw_text <<~'EOS'
      /
        foo+?
        \K
        (?=
          bar
        )
        [\p{ascii}&&\x42-\u1234[^a-z]]
        (
          qux
          (?:
              baz
            |
              bla
          )
        )
        (?(1)
          foo
        |
          bar
        )
        (?i)
        (?~
          baz
        )
        (?m-i:
          .\X\t
          \b
        ) # comment
        \k<1>
      /x
    EOS
  end
end
