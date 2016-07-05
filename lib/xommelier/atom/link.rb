# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    class Link < Xml::Element
      attribute :href, type: Uri

      may do
        attribute :rel # , type: Enum(:alternate, :related, :self, :enclosure, :via)
        attribute :type
        attribute :hreflang
        attribute :title
        attribute :length, type: Integer
      end
    end
  end
end
