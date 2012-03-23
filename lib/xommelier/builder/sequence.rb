require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Sequence < Base
      self.method_name = :sequence

      protected

      def name
        element['name'].presence
      end
    end
  end
end
