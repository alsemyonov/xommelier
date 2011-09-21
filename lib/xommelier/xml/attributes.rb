require 'xommelier/xml'
require 'active_model/attribute_methods'

module Xommelier
  module Xml
    module Attributes
      extend ActiveSupport::Concern

      included do
        include ActiveModel::AttributeMethods

        delegate :[], :[]=, to: :attributes
      end

      module ClassMethods
      end

      def attributes
        @attributes ||= AttributesProxy.new(xml_node)
      end

      def attributes=(attributes)
        attributes.merge!(attributes)
      end
    end
  end
end
