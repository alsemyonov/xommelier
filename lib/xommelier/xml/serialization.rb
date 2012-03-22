require 'xommelier/xml'
require 'nokogiri'
require 'active_support/core_ext/object/try'

module Xommelier
  module Xml
    module Serialization
      extend ActiveSupport::Concern

      module ClassMethods
        def parse(xml)
          xml = Nokogiri::XML(xml) unless xml.is_a?(Nokogiri::XML::Node)
          new(xml)
        end
        alias from_xml parse
        alias from_xommelier parse
      end

      attr_accessor :text
      def contents=(contents)
        case contents
        when Nokogiri::XML::Document
          self.xml_node = contents.root
        when Nokogiri::XML::Node
          self.xml_node = contents
        when Hash
          self.attributes = contents
        when String
          self.text = contents
        when nil
        else
          raise "Cannot use #{contents.inspect} as #{self.class} contents"
        end
      end

      def xml_document
        @xml_document ||= Nokogiri::XML::Document.new
      end

      def xml_document=(document)
        @xml_node ||= document.root
        @xml_document = document
      end

      def xml_node
        @xml_node
      end

      def xml_node=(xml_node)
        self.xml_document = xml_node.document
        @xml_node = xml_node
      end
      alias xml= xml_node=

      def to_xml
        xml_document.to_xml
      end
    end
  end
end
