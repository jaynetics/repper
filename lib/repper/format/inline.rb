module Repper
  module Format
    Inline = ->(elements, theme) do
      text = elements.map { |el| theme.colorize(el.text, el.type) }.join
      theme.add_background(text)
    end
  end
end
