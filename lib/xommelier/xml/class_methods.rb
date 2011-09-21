require 'xommelier/xml'

module Xommelier
  module Xml
    module ClassMethods
      def ns
        Xommelier::Xml::Namespace.registry
      end

      # Defines namespace used in formats
      def xmlns(href = nil, options = {}, &block)
        if href
          options[:module] ||= self
          instance_variable_set :@_xmlns, Xommelier::Xml::Namespace.new(href, options, &block)
        end
        instance_variable_get :@_xmlns
      end
    end
  end
end
