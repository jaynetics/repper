RSpec.describe Repper::Format::Inline do
  it 'renders the original Regexp, but with theme colors' do
    result = Repper.render(complex_regexp, format: :inline)
    expect(result).to have_color # due to default theme
    expect(result).to have_raw_text "/#{complex_regexp.source}/x"
  end
end
