require 'xommelier/xml'
require 'active_support/memoizable'
require 'active_support/core_ext/class/attribute'

module Xommelier
  module Xml
    class Field
      extend ActiveSupport::Memoizable

      class_attribute :default_options
      self.default_options = {
        node_type: :element,
        type: String
      }

      def initialize(name, options = {})
        @name = name
        self.options = options
      end

      attr_reader :name, :default, :node_type, :method_name, :type
      alias getter method_name

      def xpath
        if @xmlns
          "#{@xmlns}:#{name}"
        else
          name
        end
      end

      def getter
        method_name.to_sym
      end

      def setter
        :"#{method_name}="
      end

      def presence
        :"#{method_name}?"
      end

      def options=(options)
        @method_name = options.delete(:method_name) { name }
        @node_type   = options.delete(:node_type)
        @default     = options.delete(:default)
        self.type    = options.delete(:type)
        @options     = options
      end

      def type=(type)
        if type.respond_to?(:xmlns)
          @xmlns = type.xmlns.href
        end
        @type = type
      end

      def type
        @type || String
      end
    end
  end
end
