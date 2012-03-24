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

        def element_name(element_name = nil)
          @element_name = element_name if element_name
          @element_name ||= find_element_name
        end

        def root; end

        protected

        def containing_module
          @containing_module ||= ("::#{name.gsub(/::[^:]+$/, '')}").constantize
        end

        def find_element_name
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

      def xmlns(*args)
        self.class.xmlns(*args)
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
        @xml_node || xml_document && @xml_node
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
