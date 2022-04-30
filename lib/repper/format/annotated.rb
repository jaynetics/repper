module Repper
  module Format
    Annotated = ->(elements, theme) do
      table = Tabulo::Table.new(elements.reject(&:whitespace?), **TABULO_STYLE)
      table.add_column(
        :indented_text,
        styler: ->(_, string, cell) { theme.colorize(string, cell.source.type) }
      )
      table.add_column(
        :annotation,
        styler: ->(_, string, cell) { theme.colorize(string, :annotation) }
      )
      table.pack.to_s
    end
  end
end
