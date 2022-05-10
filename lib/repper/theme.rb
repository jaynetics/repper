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

    def add_background(str)
      background = @colors[:background]
      return str unless background

      # The string might already be colored. Add background color between
      # resets, so that resets are neither lost nor disrupt the background.
      str.split("\n").map do |line|
        line.split("\e[0m").map do |part|
          Rainbow(part).background(background)
        end.join
      end.join("\n")
    end
  end
end

::Dir["#{__dir__}/theme/*.rb"].each { |file| require file }
