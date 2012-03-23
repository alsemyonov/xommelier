require 'xommelier/builder/base'

module Xommelier
  class Builder
    class MinLength < Base
      self.method_name = :maximum

      def to_options
        {maximum: element['value'].to_i}
      end
    end
  end
end
