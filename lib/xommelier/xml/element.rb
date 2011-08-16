require 'xommelier/xml'
require 'xommelier/xml/element/dsl'
require 'nokogiri'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'

module Xommelier
  module Xml
    DEFAULT_OPTIONS = {
      type: String
    }
    DEFAULT_ELEMENT_OPTIONS = DEFAULT_OPTIONS.merge(
      count: :one
    )

    class Element
      extend Xommelier::Xml::Element::DSL

      class_attribute :elements, :attributes
      self.elements = {}
      self.attributes = {}

      class << self
        def xmlns(value = nil)
          if value
            @xmlns = case ns
                     when Module
                       ns.xmlns
                     else
                       ns
                     end
          end
          @xmlns ||= find_namespace
        end
        alias xmlns= xmlns

        def element_name(element_name = nil)
          @element_name = element_name if element_name
          @element_name ||= find_element_name
        end

        private

        def containing_module
          @containing_module ||= ("::#{name.gsub(/::[^:]+$/, '')}").constantize
        end

        def find_namespace
          containing_module.xmlns
        end

        def find_element_name
          name.demodulize.tableize.dasherize
        end
      end

      def initialize(contents = {}, options = {})
        @options = DEFAULT_OPTIONS.merge(options)

        @elements = {}
        @attributes = {}
        @text = nil

        case contents
        when Hash
          contents.each do |name, value|
            send("#{name}=", value)
          end
        else
          send(:text=, contents)
        end
      end

      def to_xml(options = {})
        element_name = options.delete(:element_name) { self.element_name }
        if options[:builder] # Non-root element
          builder = options.delete(:builder)
          attribute_values = {}
        else # Root element
          builder = Nokogiri::XML::Builder.new(options)
          attribute_values = {xmlns: xmlns.to_s}
        end
        attributes.each do |name, value|
          serialize_attribute(name, value, attribute_values)
        end
        builder.send(element_name, attribute_values) do |xml|
          if respond_to?(:text)
            xml.text @text
          else
            elements.each do |name, value|
              serialize_element(name, value, xml)
            end
          end
        end
        builder.to_xml
      end

      protected

      def read_element(name)
        @elements[name.to_sym]
      end

      def write_element(name, value)
        type = element_options(name)[:type]
        unless value.is_a?(type)
          value = type.new(value)
        end
        @elements[name.to_sym] = value
      end

      def remove_element(name)
        @elements.delete(name.to_sym)
      end

      def read_attribute(name)
        @attributes[name.to_sym]
      end

      def write_attribute(name, value)
        type = attribute_options(name)[:type]
        unless value.is_a?(type)
          value = type.new(value)
        end
        @attributes[name.to_sym] = value
      end

      def remove_attribute(name)
        @attributes.delete(name.to_sym)
      end

      def read_text
        @text
      end

      def write_text(text)
        @text = text
      end

      def remove_text
        @text = nil
      end

      def element_options(name)
        self.class.elements[name]
      end

      def attribute_options(name)
        self.class.attributes[name]
      end

      def element_name
        self.class.element_name
      end

      def xmlns
        self.class.xmlns
      end

      def serialize_attribute(name, value, attributes)
        attributes[name] = value.to_xommelier
      end

      def serialize_element(name, value, xml, element_options = nil)
        element_options ||= self.element_options(name)
        if element_options[:count] == :many
          single_element = element_options.merge(count: :one)
          value.each { |item| serialize_element(name, item, xml, single_element) }
        else
          case value
          when Xommelier::Xml::Element
            value.to_xml(builder: xml, element_name: name)
          else
            xml.send(name) { xml.text value.to_xommelier }
          end
        end
      end
    end
  end
end
