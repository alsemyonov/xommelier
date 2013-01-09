require 'xommelier/xml'
require 'xommelier/xml/element/structure'
require 'xommelier/xml/element/serialization'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'

module Xommelier
  module Xml
    DEFAULT_OPTIONS = {
      type: String
    }
    DEFAULT_ELEMENT_OPTIONS = DEFAULT_OPTIONS.merge(
      count: :one
    )

    class Element
      include Xommelier::Xml::Element::Structure
      include Xommelier::Xml::Element::Serialization

      attr_reader :options

      def initialize(contents = {}, options = {})
        self.options = options

        @elements = {}
        @attributes = {}
        @text = nil
        @errors = []

        self.class.attributes.each do |name, options|
          send("#{name}=", options[:default]) if options.key?(:default)
        end

        self.class.elements.each do |name, options|
          send("#{name}=", options[:default]) if options.key?(:default)
        end

        case contents
        when Hash
          contents.each do |name, value|
            send("#{name}=", value)
          end
        else
          send(:text=, contents)
        end
      end

      def options=(options = {})
        @options = options
        unless @options[:validate]
          @options[:validate] = !!xmlns.try(:schema)
        end
        @options.delete(:type)
      end

      def valid?
        validate
        @errors.empty? || @errors
      end

      def inspect
        %(#<#{self.class.name}:0x#{object_id.to_s(16)} #{inspect_contents}>)
      end

      private

      def validate
        @errors = []
        to_xml unless xml_document
        if schema
          schema.validate(xml_document).each do |error|
            @errors << error
          end
        else
          raise NoSchemaError.new(self)
        end
      end

      def inspect_contents
        [inspect_attributes, inspect_elements, inspect_text].compact.join(' ')
      end

      def inspect_attributes
        "@attributes={#{@attributes.map { |name, value| "#{name}: #{value.inspect}"}.join(', ')}}" if @attributes.any?
      end

      def inspect_elements
        "#{@elements.map { |name, value| "@#{name}=#{value.inspect}"}.join(' ')}" if @elements.any?
      end

      def inspect_text
        text.inspect if text?
      end
    end
  end
end
