require 'xommelier/xml'
require 'xommelier/utils/collection'
require 'active_support/core_ext/array/extract_options'

module Xommelier
  module Xml
    class Namespace < ::String
      class << self
        def registry
          @registry ||= Utils::Collection.new(self)
        end

        def new(href, options={})
          if key = registry.key(href)
            registry[key]
          else
            super(href, options)
          end
        end
      end

      attr_reader :prefix, :elements, :attributes
      attr_accessor :options, :module
      alias as prefix
      alias href to_s

      def initialize(href, options = {}, &block)
        super(href)
        @options = {}
        @prefix = options.delete(:prefix) { options.delete(:as) }

        self.options = options

        Xommelier::Xml::Namespace.registry[prefix] = self

        scoped(&block) if block_given?
      end

      def options=(options)
        @module = options.delete(:module) if options[:module]
        @options.merge!(options)
      end

      #def ns
        #Namespace.registry
      #end

      def schema
        self.module.schema
      end

      def scoped(&block)
        self.module.module_eval(&block)
      end

      def to_hash
        {prefix.to_s => href.to_s}
      end

      def method_missing(method, *args, &block)
        if method =~ /[a-zA-Z]+/ && method != :to_ary
          schema.find_or_create_type(method, *args, &block)
        else
          super
        end
      end
    end
  end

  def self.ns
    Xml::Namespace.registry
  end
end
