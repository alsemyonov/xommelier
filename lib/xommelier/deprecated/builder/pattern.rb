require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Pattern < Base
      self.method_name = :pattern

      def to_options
        {pattern: Regexp.compile(element['value'])}
      end
    end
  end
end
