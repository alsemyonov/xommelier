require 'active_support/concern'
require 'xommelier/xml/schema/complex_type'

module Xommelier
  module Xml
    class Schema
      module ComplexType
        module SimpleContent
          extend ActiveSupport::Concern

          included do
            extend Fields

            field(:content, type: base, node_type: :content)
          end

          def value
            content
          end

          def value=(value)
            self.content = value
          end
        end
      end
    end
  end
end
