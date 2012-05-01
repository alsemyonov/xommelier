require 'xommelier/xml'
require 'nokogiri'
require 'active_support/core_ext/object/try'

module Xommelier
  module Xml
    # @deprecated
    module Serialization
      extend ActiveSupport::Concern

      attr_reader :xml_parent

      def options=(options)
        @xml_parent = options.delete(:parent) { xml_document }
        @xml_node   = options.delete(:xml_node)
        super(options)
      end

      def xmlns(*args)
        self.class.xmlns(*args)
      end

      def node_name
        self.class.node_name
      end

      def contents=(contents)
        case contents
        when Xommelier::Xml::Node
          self.xml_node = contents.xml_node
        when Nokogiri::XML::Document
          self.xml_node = contents.root
        when Nokogiri::XML::Node
          self.xml_node = contents
        when Hash
          self.attributes = contents
        when String
          self.xml_node.content = contents
        when NilClass
        else
          raise "Cannot use #{contents.inspect} as #{self.class} contents"
        end
      end

      def xml_document
        @xml_document ||=
          @xml_node.try(:document) ||
          Nokogiri::XML::Document.new.tap do |doc|
            doc.encoding = 'utf-8'
          end
      end

      def xml_node
        @xml_node ||= xml_document.create_element(
          node_name
        ).tap do |node|
          node.default_namespace = xmlns.href
          (xml_parent || xml_document).add_child(node)
        end
      end

      def xml_node=(node)
        @xml_document = node.document
        @xml_node = node
      end

      def to_xml
        if xml_node == xml_document.root
          xml_document.to_xml
        else
          xml_node.to_xml
        end
      end

      def to_xommelier; self; end

      module ClassMethods
        def parse(xml)
          xml = case xml
                when Xommelier::Xml::Node
                  xml.xml_node
                when String
                  Nokogiri::XML(xml)
                else
                  xml
                end
          new(xml)
        end
        alias from_xml parse
        alias from_xommelier parse

        def xmlns(value = nil)
          if value
            @xmlns = case value
                     when Module
                       value.xmlns
                     else
                       value
                     end
          end
          @xmlns ||= find_namespace
        end
        alias_method :xmlns=, :xmlns

        def node_name(name = nil)
          @node_name = name if name
          @node_name ||= find_node_name
        end

        def node_type
          @node_type ||= :element
        end

        def node_type=(type)
          @node_type = type.to_sym
        end

        def root; end

        protected

        def containing_module
          @containing_module ||= ("::#{name.gsub(/::[^:]+$/, '')}").constantize
        end

        def find_node_name
          name.demodulize.underscore.dasherize
        end

        def find_namespace
          if self == containing_module
            Xommelier::Xml::DEFAULT_NS
          else
            containing_module.xmlns
          end
        end
      end
    end
  end
end
