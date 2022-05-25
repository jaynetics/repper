require_relative "repper/codemod"
require_relative "repper/command"
require_relative "repper/errors"
require_relative "repper/format"
require_relative "repper/token"
require_relative "repper/tokenizer"
require_relative "repper/theme"
require_relative "repper/version"

module Repper
  class << self
    attr_reader :format, :theme

    def call(regexp, format: self.format, theme: self.theme)
      puts render(regexp, format: format, theme: theme)
    end

    def render(regexp, format: self.format, theme: self.theme)
      tokens = Tokenizer.call(regexp)
      format = Format.cast(format)
      theme  = Theme.cast(theme)
      format.call(tokens, theme)
    end

    def format=(arg)
      @format = Format.cast(arg)
    end

    def theme=(arg)
      @theme = Theme.cast(arg)
    end
  end

  self.format = Format::Annotated
  self.theme  = Theme::Default
end
