require 'active_support/concern'
require 'xommelier/xml/schema/complex_type'
require 'xommelier/xml/schema/complex_type/structure'

module Xommelier
  module Xml
    class Schema
      module ComplexType
        module SimpleContent
          extend ActiveSupport::Concern

          included do
            extend Structure

            field(:content, type: base, node_type: :content)
          end

          def __getobj__
            content
          end

          def value=(value)
            case value
            when Hash
              self.attributes = value
            else
              self.content = value
            end
          end
        end
      end
    end
  end
end
