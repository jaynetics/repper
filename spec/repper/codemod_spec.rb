RSpec.describe Repper::Codemod do
  describe '::call' do
    it 'preserves surrounding whitespace' do
      expect(Repper::Codemod.call("//")).to eq "//"
      expect(Repper::Codemod.call(" // \n ")).to eq " // \n "
    end

    it 'renders the given regexp literals in x-mode' do
      expect(Repper::Codemod.call('/a/')).to eq "/\n  a\n/x"
    end

    it 'preserves the original / or %r notation' do
      expect(Repper::Codemod.call('//')).to eq "//"
      expect(Repper::Codemod.call('%r{}')).to eq "%r{}"
      expect(Repper::Codemod.call('%r!!')).to eq "%r!!"
    end

    it 'preserves original flags (adding x if needed)' do
      expect(Repper::Codemod.call('/a/i')).to eq "/\n  a\n/ix"
      expect(Repper::Codemod.call('/a/ix')).to eq "/\n  a\n/ix"
      expect(Repper::Codemod.call('/a  /ix')).to eq "/\n  a\n/ix"
      expect(Repper::Codemod.call('%r{a}i')).to eq "%r{\n  a\n}ix"
      expect(Repper::Codemod.call('//minimi')).to eq '//imn'
    end

    it 'can handle multiple regexps in between other code' do
      code = <<~RUBY
        foo
        re1 = /123/
        bar
        re2 = %r{456}
        baz
      RUBY
      expect(Repper::Codemod.call(code)).to eq <<~RUBY
        foo
        re1 = /
          123
        /x
        bar
        re2 = %r{
          456
        }x
        baz
      RUBY
    end

    it 'escapes whitespace to preserve it in x-mode' do
      expect(Repper::Codemod.call('/ /')).to eq "/\n  \\ \n/x"
    end

    it 'does not change already formatted regexps' do
      expect(Repper::Codemod.call("/\n  a\n/x")).to eq "/\n  a\n/x"
      expect(Repper::Codemod.call("/\n  \\ \n/x")).to eq "/\n  \\ \n/x"
    end

    it 'leaves non-regexp code as it is' do
      expect(Repper::Codemod.call('1 + 1/2')).to eq "1 + 1/2"
    end

    it 'supports regexps with embedded identifiers and constants' do
      expect(Repper::Codemod.call('/#{a}/')).to eq "/\n  \#{a}\n/x"
      expect(Repper::Codemod.call('/#{A}/')).to eq "/\n  \#{A}\n/x"
    end

    it 'ignores regexps with other embedded expressions' do
      expect(Repper::Codemod.call('/#{2 * (3)}/')).to eq '/#{2 * (3)}/'
    end

    it 'supports formatting embedded regexps' do
      expect(Repper::Codemod.call('"a#{/b/}c"')).to eq <<~'RUBY'.chomp
        "a#{/
          b
        /x}c"
      RUBY
    end

    it 'formats only the innermost regexp when regexps are nested' do
      expect(Repper::Codemod.call('/a#{/(b)/}c/')).to eq <<~'RUBY'.chomp
        /a#{/
          (
            b
          )
        /x}c/
      RUBY
    end

    it 'raises when given invalid regexps' do
      expect { Repper::Codemod.call('/\p{BAD}/') }.to raise_error(Repper::Error)
    end
  end
end
