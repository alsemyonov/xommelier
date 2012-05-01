require 'xommelier/xml/schema/named_group'
require 'xommelier/xml/schema/attributes'
require 'xommelier/xml/schema/referenced'

module Xommelier
  module Xml
    class Schema
      class AttributeGroup < NamedGroup
        include Attributes

        extend Referenced
        referenced :attribute, :attribute_group

        protected :attribute, :attribute_group
      end
    end
  end
end
