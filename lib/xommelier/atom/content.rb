# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    # The Atom content construct is defined in section 4.1.3 of the format spec.
    class Content < Xml::Element
      attribute :type
      attribute :src, type: Uri

      text
    end
  end
end
