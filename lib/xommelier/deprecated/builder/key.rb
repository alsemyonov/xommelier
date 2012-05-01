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
        element['name'].to_sym
      end

      def method_options
        {}.tap do |opts|
          opts.merge!(options_from('selector'))
          opts.merge!(options_from('field'))
        end.merge(super.except('name'))
      end
    end
  end
end
