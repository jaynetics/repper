require 'repper'
require_relative 'kernel_ext'

::Kernel.prepend(Repper::KernelExt)
