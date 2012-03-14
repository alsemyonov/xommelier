require 'xommelier/xml'
require 'xommelier/xml/namespace'

module Xommelier
  module Xml
    module ClassMethods
      def ns
        Xommelier::Xml::Namespace.registry
      end

      # Defines namespace used in formats
      def xmlns(uri = nil, options = {}, &block)
        if uri
          options[:module] ||= self
          instance_variable_set :@_xmlns, Xommelier::Xml::Namespace.new(uri, options, &block)
        end
        instance_variable_get :@_xmlns
      end
    end
  end
end
