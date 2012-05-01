require 'xommelier/builder/base'

module Xommelier
  class Builder
    class All < Base
      self.method_name = :all

      protected

      def method_options
        {}.tap do |opts|
          opts[:ns] = element['namespace'] if element['namespace']
        end.merge(super.except('namespace'))
      end
    end
  end
end
