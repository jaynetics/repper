require 'regexp_parser'

module Repper
  module Tokenizer
    module_function

    def call(regexp, delimiters: ['/', '/'], flags: nil)
      tree = Regexp::Parser.parse(regexp, options: flags =~ /x/ && Regexp::EXTENDED)
      flatten(tree, delimiters: delimiters, flags: flags)
    rescue ::Regexp::Parser::Error => e
      raise e.extend(Repper::Error)
    end

    # Turn Regexp::Parser AST back into a flat Array of visual elements
    # that match the Regexp notation.
    def flatten(exp, acc = [], delimiters: nil, flags: nil)
      # Add opening entry.
      exp.is?(:root) && acc << make_token(exp, delimiters[0])

      # Ignore nesting of invisible intermediate branches for better visuals.
      exp.is?(:sequence) && exp.nesting_level -= 1

      exp.parts.each do |part|
        if part.instance_of?(::String)
          acc << make_token(exp, part)
        else # part.is_a?(Regexp::Expression::Base)
          flatten(part, acc)
        end
      end

      exp.quantified? && flatten(exp.quantifier, acc)

      # Add closing entry.
      exp.is?(:root) && begin
        flags ||= exp.options.keys.join
        acc << make_token(exp, "#{delimiters[1]}#{flags.chars.uniq.sort.join}")
      end

      acc
    end

    def make_token(exp, text)
      Token.new(
        type:    exp.type,
        subtype: exp.token,
        level:   exp.nesting_level,
        text:    text,
        id:      exp.respond_to?(:identifier) && exp.identifier,
      )
    end
  end
end
