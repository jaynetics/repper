module Repper
  # Formatter for Ruby code containing Regexp literals
  module Codemod
    module_function

    def call(code)
      formatted_code = code.dup

      regexp_locations(code).reverse.each do |loc|
        beg_idx = code[/\A(.*\n){#{loc.beg_line}}/].size + loc.beg_char
        end_idx = code[/\A(.*\n){#{loc.end_line}}/].size + loc.end_char
        range = beg_idx..end_idx

        /\A(?<start>\/|%r.)(?<source>.*)(?<stop>[^a-z])(?<flags>[a-z]*)\z/m =~
          code[range]

        tokens = Tokenizer.call(source, delimiters: [start, stop], flags: flags)
        formatted_regexp = Format::Extended.call(tokens, Theme::Plain)

        # indent consistently by applying leading line indentation to all lines
        lead_indentation = code.lines[loc.beg_line][/^ */]
        formatted_regexp.gsub!("\n", "\n#{lead_indentation}")

        formatted_code[range] = formatted_regexp
      end

      formatted_code
    end

    require 'ripper'

    def regexp_locations(code)
      embed_level = 0
      beg_tokens = {}

      Ripper.lex(code).each.with_object([]) do |token, acc|
        case token[1]
        when :on_regexp_beg
          beg_tokens[embed_level] = token
          # nested regexp literals are not supported a.t.m., so if we're
          # in an embed, discard the location of the surrounding regexp.
          beg_tokens[embed_level - 1] = nil
        when :on_regexp_end
          next unless beg_token = beg_tokens[embed_level]

          acc << Location.new(
            beg_line: beg_token[0][0] - 1, # note: using 0-indexed line values
            beg_char: beg_token[0][1],
            end_line: token[0][0] - 1,
            end_char: token[0][1] + (token[2].length - 1), # lex includes flags
          )
        when :on_embexpr_beg # embedded expression a.k.a. interpolation (#{...})
          embed_level += 1
        when :on_embexpr_end
          embed_level -= 1
        when :on_const, :on_ident
          # OK when embedded - Regexp::Parser will treat them as literals
        else
          # other embedded expressions are not supported
          beg_tokens[embed_level - 1] = nil
        end
      end
    end

    Location = Struct.new(:beg_line, :beg_char, :end_line, :end_char,
                          keyword_init: true)
  end
end
