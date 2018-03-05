# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    class Generator < Xml::Element
      may do
        attribute :uri, type: Uri
        attribute :version
      end

      text
    end
  end
end
