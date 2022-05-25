module Repper
  module Format
    # A format that only adds color but does not change structure.
    Inline = ->(tokens, theme) do
      tokens.map { |tok| theme.colorize(tok.text, tok.type) }.join
    end
  end
end
