require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Key < Base
      self.method_name = :key

      def to_ruby
        method(name) { pass }
      end

      protected

      def name
        method_options.delete('name')
      end
    end
  end
end
