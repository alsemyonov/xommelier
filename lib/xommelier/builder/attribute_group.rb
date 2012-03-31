require 'xommelier/builder/base'

module Xommelier
  class Builder
    class AttributeGroup < Base
      self.method_name = :attribute_group

      def to_ruby
        method(name) { pass }
      end

      protected

      def name
        element['name'].try(:to_sym)
      end

      def method_options
        {}.tap do |opts|
          opts[:ref] = deprefix(element['ref']) if element['ref']
        end.merge(super.except('ref'))
      end
    end
  end
end
