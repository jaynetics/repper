# This extension does not include itself automatically,
# require 'repper/core_ext/kernel' to do so.
module Repper
  module KernelExt
    def pp(*args)
      if args[0].is_a?(Regexp) && (args.size == 1 || args.size == 2 && args[1].is_a?(Hash))
        Repper.call(args[0], **args[1].to_h)
        args[0]
      else
        super
      end
    end
  end
end
