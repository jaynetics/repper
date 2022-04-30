module Repper
  module Format
    def self.cast(arg)
      case arg
      when ::Proc             then arg
      when ::Symbol, ::String then Format.const_get(arg.capitalize) rescue nil
      when false, nil         then Format::Plain
      end || raise(Repper::ArgumentError, "unknown format #{arg.inspect}")
    end
  end
end

::Dir["#{__dir__}/format/*.rb"].each { |file| require file }
