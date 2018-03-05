# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    class Person < Xml::Element
      element :name

      may do
        element :email
        element :uri, type: Uri
      end
    end
  end
end
