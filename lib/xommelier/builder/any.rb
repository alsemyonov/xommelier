require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Any < Base
      self.method_name = :any

      protected

      def method_options
        {}.tap do |opts|
          opts[:ns] = element['namespace'] if element['namespace']
        end.merge(super.except('namespace'))
      end
    end
  end
end
