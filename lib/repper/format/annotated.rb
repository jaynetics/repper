module Repper
  module Format
    # A structured and colorized format with annotations about token types.
    Annotated = ->(tokens, theme) do
      table = Tabulo::Table.new(tokens.reject(&:whitespace?), **TABULO_STYLE)
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
