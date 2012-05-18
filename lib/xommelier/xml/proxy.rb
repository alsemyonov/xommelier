require 'xommelier/xml'
require 'active_support/core_ext/module/delegation'

module Xommelier
  module Xml
    class Proxy < Delegator
      include Enumerable

      delegate :==, :inspect, to: 'to_hash'
      delegate :fields, :field, to: '@type'
      protected :fields, :field

      def initialize(node, type)
        @node = node
        @type = type

        fields.each do |name, field|
          self[field.name] = field.default if field.default.present?
        end
        super(@node)
      end

      def [](name)
        field = field(name)
        node = @node.at_xpath(field.xpath, field.xmlns.to_hash)
        node = node.content if node.is_a?(Nokogiri::XML::Node)
        field.type.deserialize(node)
      end

      def []=(name, value)
        field = field(name)
        value = field.type.new(value) unless value.is_a?(field.type)
        value.to_xml.tap do |value|
          case field.node_type
          when :attribute
            @node[field.name] = value
          when :element
            child = @node.document.create_element(field.name, value)
            @node.add_child(child)
          when :content
            @node.content = value
          end
        end
      end

      def key?(name)
        field = field(name)
        !!@node.at_xpath(field.xpath, field.xmlns.to_hash)
      end

      def reset(name)
        field = field(name)
        self[field.name] = field.default
      end

      def keys
        fields.map { |name, field| field.name }
      end

      def value
        keys.map { |key| self[key] }
      end

      def each
        keys.each do |key|
          yield(key, self[key])
        end
      end

      def to_hash
        keys.inject({}) do |result, key|
          result[key] = self[key]
          result
        end
      end

      def replace(attrs)
        keys.each do |key|
          delete(key)
        end
        merge(attrs)
      end

      def merge!(attrs)
        attrs.each do |name, value|
          self[name] = value
        end
      end

      def to_xml
        @node.document.to_xml
      end

      def __getobj__
        @node
      end

      def __setobj__(obj)
        @node = obj
      end
    end
  end
end
