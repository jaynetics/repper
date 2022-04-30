module Repper
  module Format
    Plain = ->(elements, *) do
      elements.map(&:text).join
    end
  end
end
