module Repper
  module Format
    # A structured format with colorization.
    Structured = ->(tokens, theme) do
      table = Tabulo::Table.new(tokens.reject(&:whitespace?), **TABULO_STYLE)
      table.add_column(
        :indented_text,
        styler: ->(_, string, cell) { theme.colorize(string, cell.source.type) }
      )
      table.pack.to_s
    end
  end
end
