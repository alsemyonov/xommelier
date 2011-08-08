
require 'xommelier/xml'

module Xommelier
  module Xml
    class Attribute
      attr_reader :name, :ns, :options

      def initialize(name, options = {}, &block)
        @name = name
        @options = {}
        self.options = {count: 1..1, root: false}.merge(options)
        scoped(&block) if block_given?
      end

      def ns=(ns)
        ns.attributes[name] = self
      end

      def options=(options)
        self.ns  = options.delete(:ns) if options.key?(:ns)
        @options.merge!(options)
      end

      def scoped(&block)
        instance_exec(&block)
      end

      def inspect
        %(@#{name})
      end
    end
  end
end
