require 'xommelier/utils/collection'
require 'xommelier/xml'
require 'xommelier/xml/namespace'
require 'xommelier/schemas'
require 'active_support/core_ext/hash/indifferent_access'

module Xommelier
  module Xml
    # Represents XML Schema
    class Schema < Delegator
      attr_reader :name
      attr_reader :module, :options

      # @param name [Symbol] Schema name
      # @param options [Hash] (see #options=)
      def initialize(name, options = {}, &block)
        @name = name
        if options[:module]
          mod = options.delete(:module)
        else
          module_name = options.delete(:module_name) { name.to_s.camelize }
          mod = Module.new
          Schemas.const_set(module_name, mod)
        end
        @options = options
        super(mod)
        extend_module!

        @namespaces = Utils::Collection.new(Xml::Namespace)
        uses(options[:xmlns] || {})
        mod.module_eval(&block) if block_given?
      end

      # @overload namespaces
      #   Namespaces map used in this schema
      # @overload namespaces(namespaces_map)
      #   Set namespaces map used in this schema
      #   @param namespaces_map [Hash] hash of namespaces with +prefix+es as keys and +href+s as values
      # @return [Xommelier::Collection<Xml::Namespace>] Defined namespaces map
      def namespaces(namespaces_map = nil)
        namespaces_map.each do |prefix, href|
          if prefix == name
            namespace(href, as: prefix)
          else
            @namespaces[prefix.to_sym] = import(href, as: prefix)
          end
        end if namespaces_map
      end
      alias uses namespaces

      def ns
        @namespaces
      end

      def namespace(href = nil, options = {})
        if href
          options[:as] ||= name
          options[:module] = self.module
          @namespace = Namespace.new(href, options)
          @namespaces[@namespace.prefix.to_sym] = @namespace
        end
        @namespace
      end
      alias xmlns namespace

      def import(href, options={})
        namespace = Schemas.import(href, options)
      end

      def complex_type(name, options={}, &block)
        find_or_create_type(name, complex_type: options, &block)
      end

      def simple_type(name, options={}, &block)
        find_or_create_type(name, simple_type: options, &block)
      end

      def schema
        self
      end

      def types
        @types ||= {}.with_indifferent_access
      end

      def find_or_create_type(name, options={}, &block)
        unless types[name]
          type = options.delete(:class) {
            options[:type] ||= Type
            Class.new(options[:type])
          }
          class_name = name.to_s.camelcase.gsub(/Type$/, '')
          self.module.const_set(class_name, type)

          type.schema = schema

          types[name.to_sym] = type
        end
        type ||= types[name.to_sym]
        type.options(options)
        type.module_eval(&block) if block_given?
        type
      end

      def open_reference(ref)
        if ref.is_a?(Symbol)
          types[ref]
        else
          ref
        end
      end

      def xsd(schema = nil)
        if schema
          # If schema or schema path provided, set schema
          schema = Nokogiri::XML::Schema(open(schema).read) unless schema.is_a?(Nokogiri::XML::Node)
          @_xsd = schema
        elsif !@_xsd
          # Unless schema exists, try to autoload schema
          available_schema = Schemas.available_schemas.find { |path| path =~ /#{xmlns.try(:prefix)}\.xsd/ }
          self.xsd(available_schema) if available_schema
        else
          @_xsd = nil
        end
        @_xsd
      end


      protected

      def __getobj__
        @module
      end

      def __setobj__(obj)
        @module = obj
      end
      alias module= __setobj__

      def extend_module!
        @module.instance_variable_set(:@schema, self)
        @module.extend DSL
      end
    end
  end

  # @see Xml::Schema#initialize
  def self.schema(name, options={}, &block)
    Xml::Schema.new(name, options, &block)
  end
end

require 'xommelier/xml/schema/attributes'
require 'xommelier/xml/schema/complex_type'
require 'xommelier/xml/schema/elements'
require 'xommelier/xml/schema/simple_type'
require 'xommelier/xml/schema/type'

# Load basic XML Schema
require 'xommelier/schemas/xml_schema'
require 'xommelier/schemas/xml'
