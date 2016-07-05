# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    class Category < Xml::Element
      attribute :term

      may do
        attribute :scheme, type: Uri
        attribute :label
      end
    end
  end
end
