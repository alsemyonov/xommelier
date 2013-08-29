# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/version'
require 'xommelier/core_ext'
require 'active_support/dependencies/autoload'

module Xommelier
  extend ActiveSupport::Autoload

  autoload :Atom
  autoload :DS, 'xommelier/ds'
  autoload :OpenSearch
  autoload :OPML, 'xommelier/opml'
  autoload :RSS, 'xommelier/rss'
  autoload :Sitemap

  # Standard Xommelier Error
  class Error < ::StandardError
  end

  # This error raised when there are no schema provided but {Xommelier::Xml::Element#valid?} called.
  class NoSchemaError < Error
    def initialize(object)
      super("Cannot validate #{object} because no schema provided for validation.")
    end
  end

  # Typecasting error
  class TypeError < Error
    def initialize(object, type)
      super("Cannot typecast #{object.inspect} to #{type}")
    end
  end
end

require 'xommelier/xml'
require 'xommelier/factory_girl' if defined?(FactoryGirl)
