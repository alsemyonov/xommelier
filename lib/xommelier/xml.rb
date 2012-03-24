require 'active_support/dependencies/autoload'
require 'active_support/concern'
require 'nokogiri'

require 'xommelier'
require 'xommelier/xml/namespace'

module Xommelier
  module Xml
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    DEFAULT_NS = 'http://www.w3.org/XML/1998/namespace'

    module ClassMethods
      # Defines namespace used in formats
      def xmlns(uri = nil, options = {}, &block)
        if uri
          options[:module] ||= self
          instance_variable_set(:@_xmlns, Xommelier::Xml::Namespace.new(uri, options, &block))
        end
        instance_variable_get(:@_xmlns)
      end

      def schema(schema = nil)
        if schema
          # If schema or schema path provided, set schema
          schema = Nokogiri::XML::Schema(open(schema).read) unless schema.is_a?(Nokogiri::XML::Node)
          instance_variable_set(:@_schema, schema)
        elsif !instance_variable_defined?(:@_schema)
          # Unless schema exists, try to autoload schema
          available_schema = available_schemas.find { |path| path =~ /#{xmlns.prefix}\.xsd/ }
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

    autoload :Attributes
    autoload :AttributesProxy
    autoload :Element
    autoload :Field
    autoload :Node
    autoload :Serialization
    extend ClassMethods
    xmlns DEFAULT_NS, as: :xml

    module CommonAttributes
      def self.included(base)
        base.attribute :lang, ns: Xml.xmlns
        base.attribute :base, type: Uri, ns: Xml.xmlns
      end
    end
  end
end
