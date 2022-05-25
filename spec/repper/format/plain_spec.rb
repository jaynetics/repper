RSpec.describe Repper::Format::Plain do
  it 'simply re-renders the original Regexp' do
    result = Repper.render(complex_regexp, format: :plain)
    expect(result).not_to have_color
    expect(result).to be_functionally_equivalent_to(complex_regexp)
    expect(result).to eq "/#{complex_regexp.source}/x"
  end
end
