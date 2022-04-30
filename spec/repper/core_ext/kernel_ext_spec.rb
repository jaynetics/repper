require 'repper/core_ext/kernel_ext'

RSpec.describe Repper::KernelExt do
  it 'overrides #pp to delegate to Repper, but only for Regexps' do
    dummy = Object.new
    expect(Repper).to receive(:render).and_return('YO').at_least(:once)

    expect { dummy.send(:pp, /foo/) }.to output("/foo/\n").to_stdout

    dummy.extend(Repper::KernelExt)

    expect { dummy.send(:pp, /foo/) }.to             output("YO\n").to_stdout
    expect { dummy.send(:pp, /foo/, theme: nil) }.to output("YO\n").to_stdout
    expect { dummy.send(:pp, 42) }.to                output("42\n").to_stdout
  end
end
