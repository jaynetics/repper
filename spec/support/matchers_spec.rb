RSpec.describe 'have_color' do
  it 'matches for colorized strings' do
    expect('foo').not_to have_color
    expect { expect('foo').to have_color }
      .to raise_error(RSpec::Expectations::ExpectationNotMetError)

    expect(Rainbow('foo').color('#FF0000')).to have_color
    expect { expect(Rainbow('foo').color('#FF0000')).not_to have_color }
      .to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end
end
