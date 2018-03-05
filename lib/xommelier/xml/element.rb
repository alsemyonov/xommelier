# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/xml'
require 'xommelier/xml/element/namespace'
require 'xommelier/xml/element/structure'
require 'xommelier/xml/element/serialization'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation'

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
        @options[:validate] = !!xmlns.try(:schema) unless @options[:validate]
        @options.delete(:type)
      end

      def inspect
        %(#<#{self.class.name}:0x#{object_id.to_s(16)} #{inspect_contents}>)
      end

      delegate :match, to: :to_s

      private

      def inspect_contents
        [inspect_attributes, inspect_elements, inspect_text].compact.join(' ')
      end

      def inspect_attributes
        "@attributes={#{@attributes.map { |name, value| "#{name}: #{value.inspect}" }.join(', ')}}" if @attributes.any?
      end

      def inspect_elements
        @elements.map { |name, value| "@#{name}=#{value.inspect}" }.join(' ').to_s if @elements.any?
      end

      def inspect_text
        text.inspect if text?
      end
    end
  end
end
