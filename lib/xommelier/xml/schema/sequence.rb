require 'xommelier/xml/schema/explicit_group'
require 'xommelier/xml/schema/referenced'

module Xommelier
  module Xml
    class Schema
      class Sequence < ExplicitGroup
        include Elements

        extend Referenced
        referenced :element

        protected :element
      end
    end
  end
end
