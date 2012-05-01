require 'xommelier/builder/base'

module Xommelier
  class Builder
    class ComplexType < Base
      self.method_name = :complex_type

      def to_ruby
        method(name) { pass }
      end

      def to_options
        {complex_type: method_options}
      end

      protected

      def name
        element['name'].try(:to_sym)
      end

      def method_options
        {}.tap do |opts|
          opts[:abstract] = Code.new(element['abstract']) if element['abstract']
          opts[:mixed] = Code.new(element['mixed']) if element['mixed']
          #opts.merge!(options_from('complexContent'))
        end.merge(super.except('name', 'abstract', 'mixed'))
      end
    end
  end
end
