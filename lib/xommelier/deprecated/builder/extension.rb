require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Extension < Base
      self.method_name = :extends

      def to_ruby
        method(base) { pass }
      end

      def to_options
        {base: base}.merge(method_options)
      end

      protected

      def method_options
        super.except('base')
      end

      def base
        deprefix(element['base'])
      end
    end
  end
end
