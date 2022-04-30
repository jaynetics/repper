# This extension does not include itself automatically,
# require 'repper/core_ext/regexp' to do so.
module Repper
  ALREADY_COLORED_MARK = :@__already_colored__

  module RegexpExt
    def inspect
      Repper.prevent_color_override_by_repl
      str = Repper.render(self)
      str.instance_variable_set(Repper::ALREADY_COLORED_MARK, true)
      str
    rescue => e
      warn "Error in Repper:\n#{e.message}\n#{e.class} @ #{e.backtrace[0]}"
      super
    end
  end

  def self.prevent_color_override_by_repl
    # Must be applied lazily because REPLs may be loaded after dependencies.
    return if @prevented_color_override

    if defined?(::IRB::Color)
      ::IRB::Color.singleton_class.prepend(IRBExt)
    end

    if defined?(::Pry::SyntaxHighlighter)
      ::Pry::SyntaxHighlighter.singleton_class.prepend(PryExt)
    end

    @prevented_color_override = true
  end

  module IRBExt
    def colorize_code(v, *args, **kwars, &blk)
      v&.instance_variable_get(ALREADY_COLORED_MARK) ? v : super
    end
  end

  module PryExt
    def highlight(v, *args, **kwars, &blk)
      v&.instance_variable_get(ALREADY_COLORED_MARK) ? "\n#{v}" : super
    end
  end
end
