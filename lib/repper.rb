require_relative "repper/element"
require_relative "repper/errors"
require_relative "repper/format"
require_relative "repper/parser"
require_relative "repper/theme"
require_relative "repper/version"

module Repper
  class << self
    attr_reader :format, :theme

    def call(regexp, format: self.format, theme: self.theme)
      puts render(regexp, format: format, theme: theme)
    end

    def render(regexp, format: self.format, theme: self.theme)
      elements = Parser.call(regexp)
      format   = Format.cast(format)
      theme    = Theme.cast(theme)
      format.call(elements, theme)
    end

    def theme=(theme)
      @theme = Theme.cast(theme)
    end

    def format=(format)
      @format = Format.cast(format)
    end
  end

  self.format = Format::Annotated
  self.theme  = Theme::Default
end
