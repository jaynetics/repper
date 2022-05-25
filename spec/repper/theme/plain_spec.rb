RSpec.describe Repper::Theme::Plain do
  it 'renders without colors' do
    expect(Repper.render(basic_regexp)).to have_color
    expect(Repper.render(basic_regexp, theme: :plain)).not_to have_color
  end
end
