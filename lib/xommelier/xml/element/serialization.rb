# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/xml/element'
require 'active_support/concern'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'
require 'nokogiri'

module Xommelier
  module Xml
    class Element
      module Serialization
        extend ActiveSupport::Concern

        SERIALIZATION_OPTIONS = {
          encoding: 'utf-8'
        }.freeze
        SAVE_OPTIONS = [:save_with, :indent_text, :indent].freeze

        module ClassMethods
          def from_xml(xml, options = {})
            new({}, options).tap do |doc|
              doc.from_xml(xml, options)
            end
          end

          alias parse from_xml
          alias from_xommelier from_xml

          def ns_element(ns, element)
            [ns, element].compact.join(':')
          end

          def element_xpath(xml_doc = nil, name = nil)
            ns_element(xmlns_xpath(xml_doc), name || element_name)
          end

          def xmlns_xpath(xml_doc = nil)
            if xml_doc
              prefix = xml_doc.namespaces.key(xmlns.try(:uri))
              (prefix =~ /:/) ? prefix[6..-1] : prefix
            else
              xmlns.as
            end
          end
        end

        def from_xml(xml, options = {})
          xml = Nokogiri::XML(xml) if IO === xml || String === xml
          @_xml_node = options.delete(:node) { xml.at_xpath(element_xpath(xml.document, element_name)) }

          self.text = @_xml_node.inner_html if text? && @_xml_node.inner_html.present?

          self.class.attributes.values.each do |attribute|
            deserialize_attribute(attribute)
          end

          self.class.elements.values.each do |element|
            deserialize_element(element)
          end
        end

        alias from_xommelier from_xml

        def to_xml(options = {})
          options = SERIALIZATION_OPTIONS.merge(options)
          save_options = options.slice(:encoding, *SAVE_OPTIONS)
          options = options.except(*SAVE_OPTIONS)

          element_name = options.delete(:element_name) { self.element_name }
          element_name = element_name.to_s
          element_name << '_' if %w(text class id).include?(element_name)
          xmlns = options[:ns] || self.xmlns
          if options[:builder] # Non-root element
            builder = options.delete(:builder)
            attribute_values = {}
            namespaces = builder.doc.namespaces
            prefix = options[:prefix] || namespaces.key(xmlns.uri).try(:[], 6..-1).presence
          else # Root element
            builder = Nokogiri::XML::Builder.new(options)
            attribute_values = children_namespaces.inject(xmlns: xmlns.uri) do |hash, ns|
              hash["xmlns:#{ns.as}"] = ns.uri
              hash
            end
            attribute_values.delete("xmlns:#{xmlns.as}")
            attribute_values.delete('xmlns:xml')
            attribute_values.delete(:xmlns) if self.xmlns.default?
            namespaces = attribute_values
            prefix = nil
          end
          current_xmlns = builder.doc.namespaces[prefix ? "xmlns:#{prefix}" : 'xmlns']
          attributes.each do |name, value|
            attribute = attribute_options(name)
            attribute_name = attribute.attribute_name
            ns = attribute.ns
            if ns.uri != current_xmlns && (attr_prefix = namespaces.key(ns.uri).try(:[], 6..-1).presence)
              attribute_name = "#{attr_prefix}:#{attribute_name}"
            end
            serialize_attribute(attribute_name, value, attribute_values) if !value.nil? || attribute.required?
          end
          @_xml_node = (prefix ? builder[prefix] : builder)
                       .send(element_name, attribute_values) do |xml|
            self.class.elements.each do |name, element|
              value = elements.fetch(name, options[:default])
              next if value.nil?
              element.override(xmlns: xmlns) do
                serialize_element(name, value, xml, element)
              end
            end
            xml.text(@text) if text?
          end.instance_variable_get(:@node)
          builder.to_xml(save_options)
        end

        alias to_xommelier to_xml

        def to_hash
          attributes.dup.tap do |hash|
            @elements.each do |name, value|
              element = element_options(name)
              if element.multiple?
                if value.count > 1
                  name = element.plural
                  value = value.map(&:to_hash) if element.complex_type?
                else
                  value = value.first.to_hash
                end
              else
                value = value.to_hash if element.complex_type?
              end
              hash[name] = value
            end
            hash[:text] = text if text?
          end
        end

        # @return [Nokogiri::XML::Node]
        def to_nokogiri
          ensure_xml_document.root
        end

        def <=>(other)
          if text? && other.is_a?(String)
            text.to_s <=> other
          else
            super
          end
        end

        def ==(other)
          if text? && other.is_a?(String)
            text.to_s == other
          else
            super
          end
        end

        def =~(other)
          if text? && other.is_a?(Regexp)
            text.to_s =~ other
          else
            super
          end
        end

        def to_s
          if text?
            text.to_s
          else
            super
          end
        end

        protected

        delegate :ns_element, to: 'self.class'

        def element_xpath(xml_doc = xml_document, name = nil)
          self.class.element_xpath(xml_doc, name)
        end

        def children_namespaces(namespaces = Set[xmlns])
          elements.inject(namespaces) do |result, (name, children)|
            element = self.class.elements[name]
            result << element.ns
            result += attributes.keys.map { |attr_name| attribute_options(attr_name).ns }
            if element.complex_type?
              Array(children).each do |child|
                result += child.children_namespaces
              end
            end
            result
          end
        end

        def xml_document
          @_xml_node.try(:document)
        end

        def ensure_xml_document
          to_xml unless xml_document
          xml_document
        end

        def xmlns_xpath(xml_document = self.xml_document)
          self.class.xmlns_xpath(xml_document)
        end

        def serialize_attribute(name, value, attributes)
          attributes[name] = value.to_xommelier
        end

        # @param [Xommelier::Xml::Element::Structure::Attribute] attribute
        def deserialize_attribute(attribute)
          ns = attribute.ns
          if ns == xmlns || attribute.xml?
            send(attribute.writer, @_xml_node[attribute.attribute_name])
          else
            send(attribute.writer, @_xml_node.attribute_with_ns(attribute.attribute_name, ns.uri.to_s).try(:value))
          end
        end

        # @param [Xommelier::Xml::Element::Structure::Element] element
        def deserialize_element(element)
          nodes = @_xml_node.xpath("./#{ns_element(element.ns.as, element.element_name)}", element.ns.to_hash)
          if nodes.any?
            if element.multiple?
              children = nodes.map { |node| typecast_element(node, element) }
              send(element.plural_writer, children)
            else
              send(element.writer, typecast_element(nodes[0], element))
            end
          end
        end

        # @param [Nokogiri::XML::Node] node
        # @param [Xommelier::Xml::Element::Structure::Element] options
        def typecast_element(node, options)
          if options.complex_type?
            options.type.from_xommelier(xml_document, node: node)
          else
            options.type.from_xommelier(node.text)
          end
        end

        # @param [Object] name
        # @param [Object] value
        # @param [Object] xml
        # @param [Xommelier::Xml::Element::Structure::Element] element
        def serialize_element(name, value, xml, element)
          if element.multiple?
            element.override(multiple: false) do
              value.each do |item|
                serialize_element(name, item, xml, element)
              end
            end
          else
            xmlns = element.overridden_xmlns || self.xmlns
            prefix = (xml.doc.namespaces.key(element.ns.uri).try(:[], 6..-1).presence if xmlns != xml.doc.namespaces['xmlns'])
            case value
            when Xommelier::Xml::Element
              value.to_xommelier(
                builder: xml,
                element_name: element.element_name,
                prefix: prefix,
                ns: element.ns
              )
            else
              (prefix ? xml[prefix] : xml).send(element.serializable_element_name) do
                xml.text(value.to_xommelier)
              end
            end
          end
        end
      end
    end
  end
end
