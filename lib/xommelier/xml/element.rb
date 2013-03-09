require 'xommelier/xml'
require 'xommelier/xml/element/namespace'
require 'xommelier/xml/element/structure'
require 'xommelier/xml/element/serialization'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'

module Xommelier
  module Xml
    class Element
      include Xommelier::Xml::Element::Namespace
      include Xommelier::Xml::Element::Structure
      include Xommelier::Xml::Element::Serialization

      attr_reader :options

      def initialize(contents = {}, options = {})
        self.options = options

        @elements   = {}
        @attributes = {}
        @text       = nil
        @errors     = []

        set_default_values

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
        super
        @options = options
        unless @options[:validate]
          @options[:validate] = !!xmlns.try(:schema)
        end
        @options.delete(:type)
      end

      def inspect
        %(#<#{self.class.name}:0x#{object_id.to_s(16)} #{inspect_contents}>)
      end

      private

      def inspect_contents
        [inspect_attributes, inspect_elements, inspect_text].compact.join(' ')
      end

      def inspect_attributes
        "@attributes={#{@attributes.map { |name, value| "#{name}: #{value.inspect}" }.join(', ')}}" if @attributes.any?
      end

      def inspect_elements
        "#{@elements.map { |name, value| "@#{name}=#{value.inspect}" }.join(' ')}" if @elements.any?
      end

      def inspect_text
        text.inspect if text?
      end
    end
  end
end
