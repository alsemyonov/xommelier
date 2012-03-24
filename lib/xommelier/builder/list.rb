require 'xommelier/builder/base'

module Xommelier
  class Builder
    class List < Base
      self.method_name = :list

      protected

      def method_options
        {}.tap do |opts|
          opts[:item_type] = deprefix(element['itemType']) if element['itemType']
        end.merge(super.except('itemType'))
      end
    end
  end
end
