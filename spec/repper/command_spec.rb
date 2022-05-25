RSpec.describe Repper::Command do
  describe '::call' do
    it 'prints the return value of Codemod' do
      expect(STDIN).to receive(:read).and_return 'foo'
      expect(Repper::Codemod).to receive(:call).and_return 'bar'
      expect { Repper::Command.call([]) }.to output('bar').to_stdout
    end

    it 'warns and exits with an error code when given bad input' do
      expect(STDIN).to receive(:read).and_return '/\p{BAD}/'
      expect { Repper::Command.call([]) }
        .to output.to_stderr
        .and raise_error(SystemExit) { |e| expect(e.status).to be_nonzero }
    end
  end
end
