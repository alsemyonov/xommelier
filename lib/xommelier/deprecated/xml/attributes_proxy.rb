require 'xommelier/xml'

module Xommelier
  module Xml
    # @deprecated
    # Hash-like proxy to Nokogiri::XML::Node attributes, subelements and text
    class AttributesProxy
      include Enumerable

      # @param [Xommelier::Xml::Node] node
      def initialize(node)
        @node = node
        @klass = node.class
      end

      def keys
        if @klass.lookup_undefined_fields
          @klass.field_names + attribute_names + element_names
        else
          @klass.field_names
        end
      end

      def each
        keys.each do |key|
          yield(key, self[key])
        end
      end

      def values
        map { |key, value| value }
      end

      def count
        keys.count
      end

      def to_hash
        keys.inject({}) do |result, key|
          result[key] = self[key]
          result
        end
      end

      def include?(name)
        keys.include?(name)
      end

      def merge!(attributes)
        attributes.each do |name, value|
          self[name] = value
        end
      end

      def [](name)
        name = name.to_s
        field = @klass.fields[name]
        if field
          #puts field.inspect
          xml_node.send(field.finder_method, *field.xpath).tap do |node|
            #puts node
          end
        end
      end
      alias read_attribute []

      #def [](name)
        #name = name.to_s
        #field = @klass.fields[name]
        #if field
          #case field.node_type
          #when :attribute
            #xml_attribute(field.name).try(:value)
          #when :element
            #xml_element(field).try(:text)
          #when :text
            #xml_node.text
          #end
        #elsif @klass.lookup_undefined_fields
          #if name == 'text'
            #xml_node.text
          #elsif attributes.key?(name)
            #xml_attribute(name).value
          #elsif element_names.include?(name)
            #xml_element(name).text
          #end
        #end
      #end

      #def []=(name, value)
        #name = name.to_s
        #field = @klass.fields[name]
        #if field
          #case field.node_type
          #when :text
            #xml_node.content = value.to_xommelier
          #when :attribute
            #xml_node.attributes[field.name] = value.to_xommelier
          #when :element
            #xml_element(field).content = value.to_xommelier
          #end
        #elsif @klass.lookup_undefined_fields
          #if name == 'text'
            #xml_node.text = value
          #elsif attributes.key?(name)
            #xml_attributes(name).value = value
          #elsif element_names.include?(name)
            #xml_element(field).text = value
          #end
        #else
          #raise "#{@klass} has no field #{name}"
        #end
      #end
      #alias write_attribute []=

      #protected

      def xml_node
        @node.xml_node
      end

      #def xml_attribute(name)
        #xml_node.attributes[name]
      #end

      #def xml_element(field)
        #puts xml_node, field
        #xml_node.at_xpath(*field.xpath) ||
          #Nokogiri::XML::Element.new(field.name, xml_node.document).tap do |element|
            #xml_node.add_child(element)
          #end
      #end

      def attributes
        xml_node.attribute_nodes
      end

      def attribute_names
        @attribute_names ||= attributes.map { |attribute| attribute.name }
      end

      def elements
        xml_node.element_children
      end

      def element_names
        @element_names ||= elements.map { |element| element.name }
      end

      #def method_missing(name, *args)
        #if @node.respond_to?(name)
          #node.send(name, *args)
        #else
          #super
        #end
      #end
    end
  end
end
