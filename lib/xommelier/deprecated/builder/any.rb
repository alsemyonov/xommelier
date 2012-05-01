require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Any < Base
      self.method_name = :any

      protected

      def method_options
        {}.tap do |opts|
          opts[:ns] = element['namespace'] if element['namespace']
          opts[:process_contents] = element['processContents'].to_sym if element['processContents']
        end.merge(super.except('namespace', 'processContents'))
      end
    end
  end
end
