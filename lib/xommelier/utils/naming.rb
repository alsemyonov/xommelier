require 'xommelier/utils'

module Xommelier
  module Utils
    module Naming
      protected

      def containing_module
        @containing_module ||= "::#{name.gsub(/::[^:]+$/, '')}".constantize
      end

      def local_constant_name
        module_name.demodulize
      end

      protected

      def module_name
        if is_a?(Module)
          name
        elsif respond_to?(:module)
          self.module.name
        elsif respond_to?(:schema)
          schema.module.name
        else
          raise NoMethodError.new("No module_name for #{inspect}")
        end
      end
    end
  end
end
