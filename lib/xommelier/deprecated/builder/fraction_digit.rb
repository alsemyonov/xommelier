require 'xommelier/builder/base'

module Xommelier
  class Builder
    class FractionDigit < Base
      self.method_name = :fraction_digits

      def to_options
        {method_name => method_options}
      end

      protected

      def method_options
        {}.tap do |opts|
          opts[:value] = Code.new(element['value']) if element['value']
        end.merge(super.except('value'))
      end
    end
  end
end
