require 'xommelier/builder/base'

module Xommelier
  class Builder
    class WhiteSpace < Base
      self.method_name = :white_space

      def to_ruby
        method(value) { pass }
      end

      def to_options
        {white_space: {value: value}.merge(method_options)}
      end

      protected

      def value
        element['value']
      end

      def method_options
        {}.tap do |opts|
          if element['fixed']
            opts[:fixed] = !!(element['fixed'] == 'true')
          end
        end
      end
    end
  end
end
