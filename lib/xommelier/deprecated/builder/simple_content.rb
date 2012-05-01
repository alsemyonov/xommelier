require 'xommelier/builder/base'

module Xommelier
  class Builder
    class SimpleContent < Base
      self.method_name = :simple_content

      protected

      def method_options
        {}.tap do |opts|
          opts.merge!(options_from('extension'))
        end.merge(super)
      end
    end
  end
end
