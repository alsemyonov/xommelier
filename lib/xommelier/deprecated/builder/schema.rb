require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Schema < Base
      self.method_name = :schema

      def to_ruby
        method(prefix || :xml) do
          ''.tap do |result|
            if target_namespace
              result << indented("namespace #{format_arguments([target_namespace])}, #{format_options(as: prefix || :xml)}") << "\n"
            end
            result << pass
          end
        end
      end

      protected

      def namespaces
        @namespaces ||= element.namespaces.inject({}) do |result, (key, value)|
          result[key.gsub(/^xmlns:/, '').to_sym] = value
          result
        end
      end

      def target_namespace
        element['targetNamespace'].try(:to_s)
      end

      def prefix
        @prefix ||= namespaces.key(target_namespace).try(:to_sym)
      end

      def method_options
        {xmlns: namespaces}.merge(super.except('targetNamespace'))
      end
    end
  end
end
