require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Schema < Base
      self.method_name = :namespace

      def to_ruby
        method(namespace) { pass }
      end

      protected

      def namespace
        element['targetNamespace'].to_s
      end

      def method_options
        {as: prefix}.merge(super.except('targetNamespace'))
      end

      def prefix
        @prefix ||= element.namespaces.key(namespace).gsub(/^xmlns:/, '').to_sym
      end
    end
  end
end
