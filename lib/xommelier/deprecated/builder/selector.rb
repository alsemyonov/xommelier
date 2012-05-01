require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Selector < Base
      self.method_name = :selector

      def to_ruby
        method { pass }
      end

      def to_options
        {method_name => name}
      end

      protected

      def name
        method_options.delete('xpath')
      end
    end
  end
end
