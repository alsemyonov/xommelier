require 'xommelier/builder/base'

module Xommelier
  class Builder
    class SimpleType < Base
      self.method_name = :simple_type

      def to_ruby
        method(name) { pass }
      end

      def to_options
        {simple_type: method_options}
      end

      protected

      def name
        element['name'].try(:to_sym)
      end

      def method_options
        {}.tap do |opts|
          child = first_element_child
          opts.merge!(options_from('restriction'))
        end
      end
    end
  end
end
