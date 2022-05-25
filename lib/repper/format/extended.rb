module Repper
  module Format
    # A lightly structured format that retains parsability
    # and functional equivalence, for use in code.
    Extended = ->(tokens, theme) do
      run_types = %i[escape literal nonposixclass nonproperty
                     posixclass property set type]
      forms_run = ->(el){ run_types.include?(el.type) || el.subtype == :dot }
      prev = nil

      tokens.each.with_object(''.dup) do |tok, acc|
        # drop existing x-mode whitespace, if any
        if tok.whitespace?
          next
        # keep some tokens in line:
        # - option switches and conditions for syntactic correctness
        # - quantifiers and codepoint runs for conciseness
        elsif tok.type == :quantifier ||
              tok.subtype == :options_switch && tok.text == ')' ||
              tok.subtype == :condition ||
              prev && forms_run.call(prev) && forms_run.call(tok)
          acc << theme.colorize(tok.inlined_text, tok.type)
        # keep comments in line, too, but with padding
        elsif tok.comment?
          acc << " #{theme.colorize(tok.inlined_text, tok.type)}"
        # render root start as wtokl as empty root end in same line
        elsif tok.subtype == :root && (prev.nil? || prev.subtype == :root)
          acc << theme.colorize(tok.text, tok.type)
        # tokse, if root is not empty, ensure x-flag is present at end
        elsif tok.subtype == :root
          acc << "\n#{theme.colorize(tok.text.sub(/x?\z/, 'x'), tok.type)}"
        # render other tokens on their own lines for an indented structure,
        # e.g. groups, alternations, anchors, assertions, ...
        else
          acc << "\n#{theme.colorize(tok.indented_text, tok.type)}"
        end
        prev = tok
      end
    end
  end
end
