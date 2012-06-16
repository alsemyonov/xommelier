require 'xommelier/xml'
require 'active_support/core_ext/module/delegation'

module Xommelier
  module Xml
    class Proxy < Delegator
      class << self
        def new(node, type)
          identity_map[node] ||= super(node, type)
        end

        def identity_map
          @identity_map ||= {}
        end
      end

      delegate :==, :inspect, to: 'to_hash'
      delegate :fields, :field, to: '@type'
      protected :fields, :field

      # @param node [Nokogiri::XML::Node] actual xml node
      # @param type [Schema::Type] Xommelier type of xml node
      def initialize(node, type)
        @node = node
        @type = type
        @collections = {}

        fields.each do |name, field|
          self[field.name] = field.default if field.default.present?
        end

        super(@node)
      end

      # Reads and deserializes value of corresponding field from XML
      # @param name [String, Schema::Field] name of field or the field itself
      # @return deserialized value of field
      def [](name)
        field = field(name)
        name = field.name if name == field
        name = name.to_sym

        nodes = field_nodes(field)
        if field.plural? && name == field.plural_method__name
          collection(field)
        elsif nodes.any?
          field.type.new(nodes.first.content)
        end
      end

      # Serializes and writes value of the field
      # @param name [String, Schema::Field] name of field or the field itself
      # @param value [Object] value to be serialized and written in XML
      def []=(name, value)
        field = field(name)
        name = field.name if name == field

        unless value.is_a?(field.type)
          if field.plural? && value.is_a?(Array)
            value = value.map { |value| field.type.new(value) }
          else
            value = field.type.new(value)
          end
        end

        case field.node_type
        when :attribute
          @node[field.name] = value.to_xml
        when :element
          if field.plural? && value.is_a?(Array)
            collection(field).replace(value)
          else
            @node.add_child(
              @node.document.create_element(field.name, value.to_xml)
            )
          end
        when :content
          @node.content = value.to_xml
        end
      end

      def key?(name)
        field_nodes(name).any?
      end

      def reset(name)
        field = field(name)
        self[field.name] = field.default
      end

      def keys
        fields.map { |name, field| field.name if key?(field) }.compact
      end

      def values
        keys.map { |key| self[key] }
      end

      def each
        keys.each do |key|
          yield(key, self[key])
        end
      end

      include Enumerable

      def to_hash
        keys.inject({}) do |result, key|
          result[key] = self[key]
          result
        end
      end

      def replace!(attrs)
        keys.each do |key|
          delete(key)
        end
        merge!(attrs)
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

      protected

      def field_nodes(name)
        field = field(name)
        @node.xpath(field.xpath, field.xmlns.to_hash)
      end

      def collection(field)
        @collection[field] ||= Collection.new(@node, field)
      end
    end
  end
end

require 'xommelier/xml/proxy/collection'
