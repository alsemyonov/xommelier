# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    class Source < Xml::Element
      may do
        element :generator
        element :icon
        element :id
        element :logo
        element :rights
        element :subtitle
        element :title
        element :updated
      end
      any do
        element :author
        element :category
        element :contributor
        element :link
      end
    end
  end
end
