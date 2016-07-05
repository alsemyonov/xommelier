# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/xml'

module Xommelier
  # Implements The Atom Syndication Format
  # See RFC 4287 {http://tools.ietf.org/html/rfc4287.html}
  module Atom
    extend ActiveSupport::Autoload
    include Xommelier::Xml

    xmlns 'http://www.w3.org/2005/Atom', as: :atom

    # Elements
    autoload :Link
    autoload :Person
    autoload :Category
    autoload :Content
    autoload :Generator
    autoload :Source
    autoload :Feed
    autoload :Entry

    # Common extensions
    autoload :LinksExtension

    # Extensions
    autoload :Threading
    autoload :History
  end
end
