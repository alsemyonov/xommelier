require 'xommelier/xml'

module Xommelier
  module Xml
    class AttributesProxy
      def initialize(node)
        @node = node
      end

      def keys
        attribute_names + element_names
      end
      delegate :include?, to: :keys

      def attributes
        @node.attributes
      end

      def elements
        @node.children
      end

      def attribute_names
        @attribute_names ||= attributes.keys
      end

      def element_names
        @element_names ||= elements.map { |element| element.name }
      end

      def merge!(attributes)
        attributes.each do |name, value|
          self[name] = value
        end
      end

      def [](name)
        name = name.to_s
        if name == 'text'
          @node.text
        elsif attributes.key?(name)
          attributes[name].value
        elsif element_names.include?(name)
          elements.find { |element| element.name == name }.value
        end
      end

      def []=(name, value)
        name = name.to_s
        if name == 'text'
          @node.text = value
        elsif attributes.key?(name)
          attributes[name].value = value
        elsif element_names.include?(name)
          elements.find { |element| element.name == name }.value = value
        end
      end

      protected

      def method_missing(name, *args)
        if @node.respond_to?(name)
          node.send(name, *args)
        else
          super
        end
      end
    end
  end
end
