module Repper
  module Format
    Structured = ->(elements, theme) do
      table = Tabulo::Table.new(elements.reject(&:whitespace?), **TABULO_STYLE)
      table.add_column(
        :indented_text,
        styler: ->(_, string, cell) { theme.colorize(string, cell.source.type) }
      )
      table.pack.to_s
    end
  end
end
