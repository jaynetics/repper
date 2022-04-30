require 'repper'
require_relative 'regexp_ext'

::Regexp.prepend(Repper::RegexpExt)
