require 'xommelier/xml'

module Xommelier
  module Xml
    module ClassMethods
      def ns
        Xommelier::Xml::Namespace.registry
      end

      # Defines namespace used in formats
      def namespace(uri, options = {}, &block)
        Xommelier::Xml::Namespace.new(uri, options, &block)
      end

      def element(name, options = {})
        options = {count: must, root: false}.merge(options)
        elements[name] = options
        yield
      end

      def attribute(name, options = {})
        options = {count: must, type: String}.merge(options)
        attributes[name] = options
      end

      def any
        0..Infinity
      end

      def may
        0..1
      end

      def must
        1..1
      end
    end
  end
end
