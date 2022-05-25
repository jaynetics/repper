module Repper
  module Format
    # A no-op format, equivalent to the original Regexp#inspect.
    Plain = ->(tokens, *) do
      tokens.map(&:text).join
    end
  end
end
