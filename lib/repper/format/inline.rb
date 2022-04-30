module Repper
  module Format
    Inline = ->(elements, theme) do
      elements.map { |el| theme.colorize(el.text, el.type) }.join
    end
  end
end
