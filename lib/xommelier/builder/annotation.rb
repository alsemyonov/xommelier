require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Annotation < Base
      def to_ruby
        extract_annotation!(element)
        documentation
      end
    end
  end
end
