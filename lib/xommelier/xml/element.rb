require 'xommelier/xml/node'
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

    class Element < Node
      def contents=(contents)
        self.xml_node = Nokogiri::XML::Element.new(
          element_name,
          xml_document
        )
        xml_document.add_child(xml_node) unless xml_document.root.present?
        super(contents)
      end

      def options=(options = {})
        # options.delete(:type)
        unless options[:validate]
          options[:validate] = !!xmlns.schema
        end

        if options.key?(:element_name)
          element_name(options.delete(:element_name))
        end
        super(options)
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
        if xmlns.schema
          xmlns.schema.validate(xml_document).each do |error|
            @errors << error
          end
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
