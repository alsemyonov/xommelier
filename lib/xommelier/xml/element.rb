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

      def element(name)
        self.class.elements[name]
      end

      def attribute(name)
        self.class.attributes[name]
      end

      def element_name
        self.class.element_name
      end

      def xmlns
        self.class.xmlns
      end

      def to_xml(builder_options = {})
        if builder_options[:builder] # Non-root element
          builder = builder_options.delete(:builder)
          attribute_values = {}
        else # Root element
          builder = Nokogiri::XML::Builder.new(builder_options)
          attribute_values = {xmlns: xmlns.to_s}
        end
        attributes.each do |name, value|
          attribute = self.attribute(name)
          unless value.is_a?(attribute[:type])
            value = attribute[:type].new(value)
          end
          attribute_values[name] = value.to_xommelier
        end
        builder.send(element_name, attribute_values) do |xml|
          elements.each do |name, value|
            element = self.element(name)
            case element[:type]
            when Xommelier::Xml::Element
              element.to_xml(builder: xml)
            else
              xml.send(name) do
                xml.text value.to_xommelier
              end
            end
          end
        end
        builder.to_xml
      end
    end
  end
end
