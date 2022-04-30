require 'rainbow'

module Repper
  class Theme
    def self.cast(arg)
      case arg
      when Theme              then arg
      when ::Hash             then Theme.new(**arg)
      when ::Symbol, ::String then Theme.const_get(arg.capitalize) rescue nil
      when false, nil         then Theme::Plain
      end || raise(Repper::ArgumentError, "unknown theme #{arg.inspect}")
    end

    def initialize(**colors)
      @colors = colors
    end

    def colorize(str, type)
      color = @colors[type] || @colors[:default]
      color ? Rainbow(str).color(color).bold : str
    end
  end
end

::Dir["#{__dir__}/theme/*.rb"].each { |file| require file }
