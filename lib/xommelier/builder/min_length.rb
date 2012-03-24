require 'xommelier/builder/base'

module Xommelier
  class Builder
    class MinLength < Base
      self.method_name = :minimum

      def to_options
        {minimum: element['value'].to_i}
      end
    end
  end
end
