require 'xommelier/xml'
require 'xommelier/collection'
require 'xommelier/xml/element'
require 'active_support/core_ext/array/extract_options'

module Xommelier
  module Xml
    class Namespace
      class << self
        def registry
          @registry ||= Xommelier::Collection.new(self)
        end
      end

      attr_reader :uri, :options, :prefix, :elements, :attributes
      alias to_s uri
      alias as prefix

      def initialize(uri, options = {}, &block)
        @uri        = uri
        @options    = {}
        @elements   = Xommelier::Collection.new(Xommelier::Xml::Element)
        @prefix     = options.delete(:prefix) { options.delete(:as) }

        Xommelier::Xml::Namespace.registry[prefix] = self

        self.options = options
        scoped(&block) if block_given?
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

      def attribute(*names, &block)
        options = names.extract_options!
        names.map do |name|
          options[:ns] ||= self
          attributes.find_or_create(name, options, &block)
        end
      end

      def element(*names, &block)
        options = names.extract_options!
        names.map do |name|
          options[:ns] ||= self
          elements.find_or_create(name, options, &block)
        end
      end

      def to_hash
        {prefix.to_s => uri.to_s}
      end

      def inspect
        %(xmlns:#{prefix}="#{uri}")
      end

      protected

      def define_module!
        options[:module]
      end
    end
  end
end
