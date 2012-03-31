require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Restriction < Base
      self.method_name = :restrict

      protected

      def method_options
        {base: deprefix(element['base'])}.tap do |opts|
          enumerations = element.xpath('./xs:enumeration')
          if enumerations.any?
            opts[:enumeration] = enumerations.inject([]) do |result, child|
              result << child['value']
              child.remove
              result
            end
          end
          element.xpath('./*').each do |child|
            if wrapped_child = self.class.wrapper(child, options)
              opts.merge!(wrapped_child.to_options)
              @removed_children ||= []
              @removed_children += child.element_children
              child.remove
            end
          end
        end
      end

      def namespace
        element['namespace'].to_s
      end
    end
  end
end
