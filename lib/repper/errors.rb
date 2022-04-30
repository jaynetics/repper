module Repper
  module Error; end

  class ArgumentError < ::ArgumentError
    include Repper::Error
  end
end
