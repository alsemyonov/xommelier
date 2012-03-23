require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Import < Base
      self.method_name = :import

      def to_ruby
        method(namespace) { pass }
      end

      protected

      def namespace
        element['namespace'].to_s
      end
    end
  end
end
