require 'tabulo'

module Repper
  module Format
    TABULO_STYLE = {
      border:               :blank, # i.e. don't draw borders
      header_frequency:     nil, # i.e. omit column headers
      truncation_indicator: '…',
      wrap_body_cells_to:   1,
    }
  end
end
