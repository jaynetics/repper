RSpec.describe Repper::Theme::Monokai do
  it 'renders with colors' do
    expect(Repper.render(basic_regexp, theme: :monokai)).to have_color
  end
end
