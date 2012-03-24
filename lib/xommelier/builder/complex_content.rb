require 'xommelier/builder/base'

module Xommelier
  class Builder
    class ComplexContent < Base
      self.method_name = :complex_content

      protected

      def method_options
        {}.tap do |opts|
          opts.merge!(options_from('restriction'))
          opts.merge!(options_from('extension'))
        end.merge(super)
      end

      def prefix
        @prefix ||= element.namespaces.key(namespace).gsub(/^xmlns:/, '').to_sym
      end
    end
  end
end
