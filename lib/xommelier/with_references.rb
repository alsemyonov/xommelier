require 'delegate'

module Xommelier
  module WithReferences
    class Reference < Delegator
      def initialize(object)
        super(object)
      end

      def reference_name
        @reference_name ||= :"reference_#{object_id}"
      end

      def __getobj__
        @__obj__
      end

      def __setobj__(obj)
        @__obj__ = obj
      end
    end

    def self.included(base)
      base.send(:alias_method, :each_without_references, :each)
      super
    end

    def self.extend_object(base)
      base.singleton_class.class_eval do
        alias each_without_references each
      end
      super
    end

    def each(&block)
      super do |key, value|
        if reference?(value)
          value.each do |key, value|
            yield(key, value)
          end
        else
          yield(key, value)
        end
      end
    end

    def keys
      map { |key, value| key }
    end

    def values
      map { |key, value| value }
    end

    def include?(object)
      super(object) || references.any? { |ref| ref.include?(object) }
    end

    def add_reference(object)
      Reference.new(object).tap do |ref|
        self[ref.reference_name] = ref
        self.references << ref
      end
    end
    alias << add_reference

    def inspect
      result = []
      each_without_references do |key, value|
        result << if reference?(value)
                    "*#{value.inspect}"
                  else
                    "#{key.inspect}=>#{value.inspect}"
                  end
      end
      "{#{result.join(', ')}}"
    end

    protected

    def references
      @references ||= []
    end

    def reference?(value)
      references.include?(value)
    end
  end

  class HashWithReferences < Hash
    include WithReferences
  end
end
