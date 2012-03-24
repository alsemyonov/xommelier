require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Restriction < Base
      self.method_name = :restriction

      protected

      def method_options
        {base: deprefix(element['base'])}.tap do |opts|
          child = first_element_child
          if child.try(:name) == 'enumeration'
            opts[:enumeration] = element.xpath('./xs:enumeration').inject([]) do |result, child|
              result << child['value']
              child.remove
              result
            end
          end
          opts.merge!(options_from('pattern'))
          opts.merge!(options_from('whiteSpace'))
          opts.merge!(options_from('minInclusive'))
          opts.merge!(options_from('maxInclusive'))
          opts.merge!(options_from('minLength'))
          opts.merge!(options_from('maxLength'))
        end
      end

      def namespace
        element['namespace'].to_s
      end
    end
  end
end
