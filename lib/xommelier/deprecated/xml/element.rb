require 'xommelier/xml/node'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'

module Xommelier
  module Xml
    # @deprecated
    class Element < Node
      def self.element_name(name = nil)
        @element_name = name if name
        @element_name ||= self.name.demodulize.underscore.dasherize
      end

      def valid?
        validate
        @errors.empty? || @errors
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
