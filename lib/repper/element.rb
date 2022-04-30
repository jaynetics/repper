module Repper
  Element = Struct.new(:type, :subtype, :level, :text, :id, keyword_init: true) do
    def indented_text
      inlined_text = text.gsub(/[\n\r\t\v]/) { |ws| ws.inspect.delete(?") }
      "#{'  ' * level}#{inlined_text}"
    end

    def whitespace?
      subtype == :whitespace
    end

    def annotation
      case [type, subtype]
      in [_, :root]
        nil
      in [_, :alternation | :comment | :condition | :intersection | :range => subtype]
        subtype
      in [:conditional | :free_space => type, _]
        type
      in [:group, :capture | :named]
        "capture group #{id}"
      in [:meta, :dot]
        'match-all'
      in [:keep, :mark]
        'keep-mark lookbehind'
      in [type, subtype]
        [subtype, type].uniq.join(' ')
      end.to_s.tr('_', ' ')
    end
  end
end
