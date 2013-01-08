require 'xommelier'
require 'nokogiri'
require 'xommelier/xml/namespace'
require 'active_support/concern'

module Xommelier
  module Xml
    extend ActiveSupport::Concern

    DEFAULT_NS = 'http://www.w3.org/XML/1998/namespace'

    module ClassMethods
      def ns
        Xommelier::Xml::Namespace.registry
      end

      # Defines namespace used in formats
      def xmlns(uri = nil, options = {}, &block)
        if uri
          options[:module] ||= self
          instance_variable_set(:@_xmlns, Xommelier::Xml::Namespace.new(uri, options, &block))
        end
        instance_variable_get(:@_xmlns) || Xml.xmlns
      end

      def schema(schema = nil)
        if schema
          # If schema or schema path provided, set schema
          schema = Nokogiri::XML::Schema(open(schema).read) unless schema.is_a?(Nokogiri::XML::Node)
          instance_variable_set(:@_schema, schema)
        elsif !instance_variable_defined?(:@_schema)
          # Unless schema exists, try to autoload schema
          available_schema = available_schemas.find { |path| path =~ /#{xmlns.as}\.xsd/ }
          self.schema(available_schema) if available_schema
        else
          instance_variable_set(:@schema, nil)
        end
        instance_variable_get(:@_schema)
      end

      protected

      def available_schemas
        @_available_schemas ||= $:.map do |path|
          Dir[File.join(path, 'xommelier/schemas', '*.xsd')]
        end.flatten.uniq
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
      attribute :lang, ns: Xml.xmlns, as: 'xml:lang'
      attribute :base, type: Uri, ns: Xml.xmlns, as: 'xml:base'
    end
  end
end
