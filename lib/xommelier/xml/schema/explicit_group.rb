require 'xommelier/xml/schema/group'
require 'xommelier/xml/schema/elements'

module Xommelier
  module Xml
    class Schema
      class ExplicitGroup < Group
        include Elements
      end
    end
  end
end
