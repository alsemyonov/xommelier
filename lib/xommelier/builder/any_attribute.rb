require 'xommelier/builder/base'

module Xommelier
  class Builder
    class AnyAttribute < Base
      self.method_name = :any_attribute

      protected

      def method_options
        {}.tap do |opts|
          opts[:ns] = element['namespace'] if element['namespace']
        end.merge(super.except('namespace'))
      end
    end
  end
end
