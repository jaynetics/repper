require 'regexp_parser'

module Repper
  # Uses Regexp::Parser to get the AST of a Regexp, and turns that AST
  # into a flat Array of visual elements that match the Regexp notation.
  module Tokenizer
    module_function

    def call(regexp, delimiters: ['/', '/'], flags: nil)
      tree = Regexp::Parser.parse(regexp, options: flags =~ /x/ && Regexp::EXTENDED)
      flatten(tree, delimiters: delimiters, flags: flags)
    rescue ::Regexp::Parser::Error => e
      raise e.extend(Repper::Error)
    end

    def flatten(exp, acc = [], delimiters: nil, flags: nil)
      # Add opening entry.
      exp.is?(:root) && acc << Token.new(exp, delimiters[0])

      # Ignore nesting of invisible intermediate branches for better visuals.
      exp.is?(:sequence) && exp.nesting_level -= 1

      exp.parts.each do |part|
        if part.instance_of?(::String)
          acc << Token.new(exp, part)
        else # part.is_a?(Regexp::Expression::Base)
          flatten(part, acc)
        end
      end

      exp.quantified? && flatten(exp.quantifier, acc)

      # Add closing entry.
      exp.is?(:root) && begin
        flags ||= exp.options.keys.join
        acc << Token.new(exp, "#{delimiters[1]}#{flags.chars.uniq.sort.join}")
      end

      acc
    end
  end
end
