require 'xommelier/builder/base'

module Xommelier
  class Builder
    class MaxInclusive < Base
      self.method_name = :max

      def to_options
        {gte: element['value'].to_i}
      end
    end
  end
end
