require 'regexp_parser'

module Repper
  module Parser
    module_function

    def call(regexp)
      tree = ::Regexp::Parser.parse(regexp)
      flatten(tree)
    rescue ::Regexp::Parser::Error => e
      raise e.extend(Repper::Error)
    end

    # Turn Regexp::Parser AST back into a flat Array of visual elements
    # that match the Regexp notation.
    def flatten(exp, acc = [])
      # Add opening entry.
      exp.is?(:root) && acc << make_element(exp, '/')

      # Ignore nesting of invisible intermediate branches for better visuals.
      exp.is?(:sequence) && exp.nesting_level -= 1

      exp.parts.each do |part|
        if part.instance_of?(::String)
          acc << make_element(exp, part)
        else # part.is_a?(Regexp::Expression::Base)
          flatten(part, acc)
        end
      end

      exp.quantified? && flatten(exp.quantifier, acc)

      # Add closing entry.
      exp.is?(:root) && acc << make_element(exp, "/#{exp.options.keys.join}")

      acc
    end

    def make_element(exp, text)
      Element.new(
        type:    exp.type,
        subtype: exp.token,
        level:   exp.nesting_level,
        text:    text,
        id:      exp.respond_to?(:identifier) && exp.identifier,
      )
    end
  end
end
