require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Attribute < Base
      self.method_name = :attribute

      def to_ruby
        method(name) { pass }
      end

      protected

      def name
        element['name'].try(:to_sym)
      end

      def method_options
        {}.tap do |opts|
          opts[:type] = deprefix(element['type']) if element['type']
          opts.merge!(options_from('simpleType'))
        end.merge(super.except('type', 'name'))
      end
    end
  end
end
