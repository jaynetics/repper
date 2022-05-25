RSpec.describe Repper::Theme::Default do
  it 'is the default' do
    expect(Repper.render(basic_regexp))
      .to eq(Repper.render(basic_regexp, theme: :default))
  end

  it 'renders with colors' do
    expect(Repper.render(basic_regexp, theme: :default)).to have_color
  end
end
