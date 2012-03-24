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

      attr_reader :href, :options, :prefix, :elements, :attributes
      alias to_s href
      alias as prefix

      def initialize(href, options = {}, &block)
        @href       = href
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
        options[:module] ||= begin
                               module_name = prefix.to_s.camelcase
                               if ::Xommelier.const_defined?(module_name)
                                 raise "Module Xommelier::#{module_name} already defined"
                               end
                               Module.new { extend Xommelier::DSL::Namespace }.tap do |mod|
                                 ::Xommelier.const_set(module_name, mod)
                               end
                             end
      end

      def schema
        self.module.schema
      end

      def scoped(&block)
        self.module.module_eval(&block)
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
        {prefix.to_s => href.to_s}
      end

      def inspect
        %(xmlns:#{prefix}="#{href}")
      end

      protected

      def define_module!
        options[:module]
      end
    end
  end
end
