# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier'
require 'nokogiri'
require 'xommelier/xml/namespace'
require 'active_support/concern'
require 'xommelier/xml/schema'

module Xommelier
  module Xml
    extend ActiveSupport::Concern

    DEFAULT_NS = 'http://www.w3.org/XML/1998/namespace'.freeze

    module ClassMethods
      include Schema

      # Defines namespace used in formats
      def xmlns(uri = nil, options = {}, &block)
        if uri
          options[:module] ||= self
          instance_variable_set(:@_xmlns, Xommelier::Xml::Namespace.new(uri, options, &block))
        end
        instance_variable_get(:@_xmlns) || Xml.xmlns
      end
    end

    included do
      instance_variable_set :@_xmlns, nil
    end

    # Define XML default namespace
    extend ClassMethods

    xmlns DEFAULT_NS, as: :xml

    # Inject common XML attributes to every XML element
    require 'xommelier/xml/element'
    class Element
      attribute :lang, optional: true, xml: true
      attribute :base, type: Uri, optional: true, xml: true
    end
  end
end
