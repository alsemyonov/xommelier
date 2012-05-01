require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Element < Base
      self.method_name = :element

      def to_ruby
        method(name) { pass }
      end

      protected

      def name
        element['name'].try(:to_sym)
      end

      def method_options
        super.except('name')
      end
    end
  end
end
