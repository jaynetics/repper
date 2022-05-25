require 'repper'
require_relative 'regexp_ext'

Regexp.alias_method :original_inspect, :inspect

::Regexp.prepend(Repper::RegexpExt)
