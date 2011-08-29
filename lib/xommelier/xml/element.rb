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
        @options.delete(:type)

        if @options.key?(:element_name)
          element_name(@options.delete(:element_name))
        end
      end
    end
  end
end
