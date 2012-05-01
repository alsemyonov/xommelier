require 'xommelier/utils'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/object/try'

module Xommelier
  module Utils
    class Collection < ::ActiveSupport::HashWithIndifferentAccess
      def initialize(klass)
        @klass = klass
      end

      def key(value)
        super(value) || find { |key, item| item.to_s == value }.try(:[], 0)
      end

      def find_and_append(key, options = {}, &block)
        self[key].tap do |item|
          item.options = options
          item.scoped(&block) if block_given?
        end
      end

      def find_or_create(name, options = {}, &block)
        if key = key(name)
          find_and_append(key, options, &block)
        else
          @klass.new(name, options, &block)
        end
      end

      def respond_to?(name)
        super(name) || key?(name)
      end

      def method_missing(name, options = {}, &block)
        if key?(name)
          find_and_append(name, options, &block)
        else
          super
        end
      end
    end
  end
end
