module Repper
  class Theme
    Default = new(
      anchor:        :yellow,
      annotation:    nil, # only for annotated formats
      assertion:     :green,
      background:    nil, # use terminal default
      backref:       :blue,
      conditional:   :green,
      escape:        :red,
      expression:    :red, # root
      free_space:    nil,
      group:         :blue,
      keep:          :yellow,
      literal:       :red,
      meta:          :magenta,
      nonposixclass: :cyan,
      nonproperty:   :cyan,
      posixclass:    :cyan,
      property:      :cyan,
      quantifier:    :white,
      set:           :cyan,
      type:          :cyan,
    )
  end
end
