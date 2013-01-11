require 'xommelier/xml'
require 'xommelier/xml/element'
require 'active_support/core_ext/array/extract_options'

module Xommelier
  module Xml
    class Namespace
      attr_reader :uri, :options, :elements, :attributes
      alias to_s uri

      def initialize(uri, options = {}, &block)
        @uri     = uri
        @options = {}
        @as      = options.delete(:as)

        self.options = options
        scoped(&block) if block_given?
      end

      def as
        @as unless default?
      end

      def ns
        Xommelier::Xml::Namespace.registry
      end

      def options=(options)
        options.delete(:elements) { [] }.each do |name|
          element(name)
        end
        options.delete(:attributes) { [] }.each do |name|
          attribute(name)
        end
        @options.merge!(options)
      end

      def module
        options[:module]
      end

      def schema
        self.module.schema
      end

      def scoped(&block)
        instance_exec(&block)
      end

      def default?
        uri.to_s == DEFAULT_NS
      end

      def to_hash
        {as.to_s => uri.to_s}
      end

      def attribute_name
        default? ? 'xmlns' : "xmlns:#{as}"
      end

      def inspect
        %(#{attribute_name}="#{uri}")
      end
    end
  end
end
