require 'repper/core_ext/regexp_ext'

RSpec.describe Repper::RegexpExt do
  it 'overrides Regexp#inspect to use Repper' do
    expect(Repper).to receive(:render).and_return('YO').at_least(:once)
    expect(/foo/.inspect).to eq '/foo/'
    expect(/foo/.dup.extend(Repper::RegexpExt).inspect).to eq 'YO'
  end
end
