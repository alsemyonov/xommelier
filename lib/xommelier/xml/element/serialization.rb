require 'xommelier/xml/element'
require 'active_support/concern'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

module Xommelier
  module Xml
    class Element
      module Serialization
        extend ActiveSupport::Concern

        SERIALIZATION_OPTIONS = {
          encoding: 'utf-8'
        }

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
              prefix = xml_document.namespaces.key(xmlns.uri)
              (prefix =~ /:/) ? prefix[6..-1] : prefix
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
          options = SERIALIZATION_OPTIONS.merge(options)
          element_name = options.delete(:element_name) { self.element_name }
          if options[:builder] # Non-root element
            builder = options.delete(:builder)
            attribute_values = {}
            prefix = builder.doc.namespaces.key(xmlns.uri)[6..-1].presence
          else # Root element
            builder = Nokogiri::XML::Builder.new(options)
            attribute_values = children_namespaces.inject({xmlns: xmlns.uri}) do |hash, ns|
              hash["xmlns:#{ns.as}"] = ns.uri
              hash
            end
            attribute_values.delete("xmlns:#{xmlns.as.to_s}")
            attribute_values.delete("xmlns:xml")
            prefix = nil
          end
          current_xmlns = builder.doc.namespaces[prefix ? "xmlns:#{prefix}" : 'xmlns']
          attributes.each do |name, value|
            attribute_options = attribute_options(name)
            attribute_name = attribute_options[:attribute_name]
            if (ns = attribute_options[:ns]).uri != current_xmlns
              if ns.as == :xml
                attribute_name = "xml:#{attribute_options[:attribute_name]}"
              elsif attr_prefix = builder.doc.namespaces.key(ns.uri).try(:[], 6..-1).presence
                attribute_name = "#{attr_prefix}:#{attribute_options[:attribute_name]}"
              end
            end
            serialize_attribute(attribute_name, value, attribute_values)
          end
          (prefix ? builder[prefix] : builder).
            send(element_name, attribute_values) do |xml|
              elements.each do |name, value|
                serialize_element(name, value, xml, element_options(name).merge(parent_ns_prefix: prefix))
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

        def children_namespaces(namespaces = Set[xmlns])
          elements.inject(namespaces) do |result, (name, children)|
            element_options = self.class.elements[name]
            result << element_options[:ns]
            result += attributes.keys.map { |name| attribute_options(name)[:ns] }
            if element_options[:type] < Xml::Element
              Array(children).each do |child|
                result += child.children_namespaces
              end
            end
            result
          end
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
          nodes = @_xml_node.xpath("./#{options[:ns].as}:#{options[:element_name]}", options[:ns].to_hash)
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

        def serialize_element(name, value, xml, options = {})
          prefix = if options[:ns].try(:!=, xmlns)
                     xml.doc.namespaces.key(options[:ns].uri)[6..-1].presence
                   else
                     nil
                   end
          case options[:count]
          when :any, :many
            single_element = options.merge(count: :one)
            value.each { |item| serialize_element(name, item, xml, single_element) }
          else
            case value
            when Xommelier::Xml::Element
              value.to_xommelier(builder: xml, element_name: options[:element_name])
            else
              (prefix ? xml[prefix] : xml).send(options[:element_name]) { xml.text value.to_xommelier }
            end
          end
        end
      end
    end
  end
end
