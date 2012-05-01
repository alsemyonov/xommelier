require 'xommelier/builder/base'

module Xommelier
  class Builder
    class WhiteSpace < Base
      self.method_name = :white_space

      def to_ruby
        method(value) { pass }
      end

      def to_options
        {method_name => {value: value}.merge(method_options)}
      end

      protected

      def value
        element['value']
      end

      def method_options
        super.except('value')
      end
    end
  end
end
