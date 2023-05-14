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

    require 'tempfile'

    it 'takes pathes as arguments' do
      file_1 = "#{Dir.tmpdir}/#{rand}.rb"
      file_2 = "#{Dir.tmpdir}/#{rand}.rb"
      File.write(file_1, 'foo')
      File.write(file_2, 'foo')
      expect(Repper::Codemod).to receive(:call).twice.and_return 'bar'

      Repper::Command.call([file_1, file_2])

      expect(File.read(file_1)).to eq 'bar'
      expect(File.read(file_2)).to eq 'bar'
    end
  end
end
