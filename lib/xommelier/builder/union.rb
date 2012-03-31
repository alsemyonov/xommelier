require 'xommelier/builder/base'

module Xommelier
  class Builder
    class Union < Base
      self.method_name = :union

      protected

      def method_options
        {}.tap do |opts|
          if element['memberTypes']
            opts[:member_types] = element['memberTypes'].split(/\ +/).map { |type| deprefix(type) }
          end
        end.merge(super.except('memberTypes'))
      end
    end
  end
end
