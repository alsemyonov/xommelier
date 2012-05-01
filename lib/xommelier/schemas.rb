require 'xommelier/xml/namespace'
require 'xommelier/xml/schema'

module Xommelier
  # All defined Schemas
  module Schemas
    class << self
      def cleanup!
        constants.each do |constant|
          remove_const(constant) unless constant.to_sym == :XmlSchema
        end
      end

      def available_schemas
        @_available_schemas ||= $:.map do |path|
          Dir[File.join(path, 'xommelier/schemas', '*.xsd')]
        end.flatten.uniq
      end

      def register(href, options)
        if options[:require]
          file_name = options.delete(:require)
          namespace = ::Xommelier::Xml::Namespace.new(href, options)
          registered_schemas[namespace] = file_name
        else
          raise LoadError.new("Xommelier::Schemas.register should provide :require option, #{options} was provided")
        end
      end

      def import(href, options={})
        namespace = ::Xommelier::Xml::Namespace.new(href, options)
        file_name = registered_schemas[namespace]
        if file_name
          require(file_name)
          namespace
        else
          raise LoadError.new("Could not load #{namespace} namespace")
        end
      end

      def registered_schemas
        @registered_schemas ||= {}
      end
    end

    register 'http://www.w3.org/2001/XMLSchema',     as: :xs,   require: 'xommelier/schemas/xml_schema'
    register 'http://www.w3.org/XML/1998/namespace', as: :xml,  require: 'xommelier/schemas/xml'
    register 'http://www.w3.org/2005/Atom',          as: :atom, require: 'xommelier/schemas/atom'
  end
end
