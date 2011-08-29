require 'xommelier/xml/element'
require 'active_support/concern'
require 'nokogiri'

module Xommelier
  module Xml
    class Element
      module Serialization
        extend ActiveSupport::Concern

        module ClassMethods
          def from_xml(xml, options = {})
            new.tap do |doc|
              doc.options = options
              doc.from_xml(xml, options)
            end
          end
          alias_method :parse, :from_xml
          alias_method :from_xommelier, :from_xml

          def element_xpath(xmldoc = nil, name = nil)
            "#{xmlns_xpath(xmldoc)}:#{name || element_name}"
          end

          def xmlns_xpath(xml_document = nil)
            if xml_document
              xml_document.namespaces.key(xmlns.uri)
            else
              xmlns.as
            end
          end
        end

        def from_xml(xml, options = {})
          case xml
          when IO, String
            xml = Nokogiri::XML(xml)
          end
          @_xml_node = options.delete(:node) { xml.at_xpath(element_xpath(xml.document, element_name)) }

          if text? && @_xml_node.text?
            self.text = @_xml_node.text
          end

          self.class.attributes.each do |name, options|
            send(name, @_xml_node[name])
          end

          self.class.elements.each do |name, options|
            deserialize_element(name, options)
          end
        end
        alias_method :from_xommelier, :from_xml

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
            elements.each do |name, value|
              serialize_element(name, value, xml)
            end
            if respond_to?(:text)
              xml.text @text
            end
          end
          builder.to_xml
        end
        alias_method :to_xommelier, :to_xml

        protected

        def element_xpath(xmldoc = self.xml_document, name = nil)
          self.class.element_xpath(xmldoc, name)
        end

        def xml_document
          @_xml_node.document
        end

        def xmlns_xpath(xml_document = self.xml_document)
          self.class.xmlns_xpath(xml_document)
        end

        def serialize_attribute(name, value, attributes)
          attributes[name] = value.to_xommelier
        end

        def deserialize_element(name, options = nil)
          options ||= self.element_options(name)
          type = options[:type]
          xpath = if type < Xommelier::Xml::Element
                    type.element_xpath(xml_document, name)
                  else
                    element_xpath(xml_document, name)
                  end
          nodes = @_xml_node.xpath("./#{xpath}")
          if nodes.any?
            case options[:count]
            when :any, :many
              children = nodes.map { |node| typecast_element(type, node, options) }
              send options[:plural], children
            else
              send(name, typecast_element(type, nodes[0], options))
            end
          end
        end

        def typecast_element(type, node, options)
          if type < Xommelier::Xml::Element
            type.from_xommelier(xml_document, options.merge(node: node))
          else
            type.from_xommelier(node.text)
          end
        end

        def serialize_element(name, value, xml, options = nil)
          options ||= self.element_options(name)
          case options[:count]
          when :any, :many
            single_element = options.merge(count: :one)
            value.each { |item| serialize_element(name, item, xml, single_element) }
          else
            case value
            when Xommelier::Xml::Element
              value.to_xommelier(builder: xml, element_name: name)
            else
              xml.send(name) { xml.text value.to_xommelier }
            end
          end
        end
      end
    end
  end
end
