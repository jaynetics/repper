require 'repper/core_ext/regexp_ext'
require 'irb/color_printer'
require 'pry'

RSpec.describe Repper::RegexpExt do
  it 'overrides Regexp#inspect to use Repper' do
    expect(Repper).to receive(:render).and_return('YO').at_least(:once)
    expect(/foo/.inspect).to eq '/foo/'
    expect(/foo/.dup.extend(Repper::RegexpExt).inspect).to eq 'YO'
  end

  it 'gracefully handles errors' do
    expect(Repper).to receive(:render).and_raise('oopsy')
    expect do
      expect(/foo/.dup.extend(Repper::RegexpExt).inspect).to eq '/foo/'
    end.to output(/Error in Repper:.*oopsy/m).to_stderr
  end

  describe 'REPL rendering' do
    let(:regexp) { /foo+/.dup.extend(described_class) }
    let(:rendered) { Repper.render(regexp) }

    before { regexp.inspect } # install the REPL hooks through the public entry point

    context 'in IRB' do
      it 'preserves Repper formatting and colors during syntax highlighting' do
        expect(rendered).to have_color
        expect(IRB::Color.colorize_code(regexp.inspect, colorable: true)).to eq rendered
      end

      it 'pretty prints regexps without changing their formatting or colors' do
        allow(IRB::Color).to receive(:colorable?).and_return(true)

        expect(IRB::ColorPrinter.pp(regexp, +'', 80)).to eq "#{rendered}\n"
      end

      it 'still highlights ordinary Ruby code' do
        result = IRB::Color.colorize_code('true', colorable: true)

        expect(result).to have_color
        expect(result).to have_raw_text('true')
      end
    end

    context 'in Pry' do
      it 'preserves Repper formatting and colors and starts output on a new line' do
        expect(rendered).to have_color
        expect(Pry::SyntaxHighlighter.highlight(regexp.inspect)).to eq "\n#{rendered}"
      end

      it 'pretty prints regexps without changing their formatting or colors' do
        expect(Pry::ColorPrinter.pp(regexp, +'', 80)).to eq "#{rendered}\e[0m\n"
      end

      it 'still highlights ordinary Ruby code' do
        result = Pry::SyntaxHighlighter.highlight('true')

        expect(result).to have_color
        expect(result).to have_raw_text('true')
      end
    end
  end
end
