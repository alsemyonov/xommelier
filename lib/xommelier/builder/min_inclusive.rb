require 'xommelier/builder/base'

module Xommelier
  class Builder
    class MinInclusive < Base
      self.method_name = :min

      def to_options
        {lte: element['value'].to_i}
      end
    end
  end
end
