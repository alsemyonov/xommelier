require 'xommelier'

module Xommelier
  class Collection < Hash
    def initialize(klass)
      @klass = klass
    end

    def respond_to?(name)
      key?(name) || super(name)
    end

    def key(value)
      super(value) || find { |key, item| item.to_s == value }.try(:[], 1)
    end

    def find_and_append(name, options = {}, &block)
      item = self[name]
      item.options = options
      if block_given?
        item.scoped(&block)
      end
      item
    end

    def method_missing(name, options = {}, &block)
      if key?(name)
        find_and_append(name, options, &block)
      else
        super
      end
    end

    def find_or_create(name, options = {}, &block)
      if key?(name)
        find_and_append(name, options, &block)
      else
        @klass.new(name, options, &block)
      end
    end

    def inspect
      values.map { |value| value.inspect }.inspect
    end

    def pretty_inspect
      values.map { |value| value.inspect }.pretty_inspect
    end
  end
end
