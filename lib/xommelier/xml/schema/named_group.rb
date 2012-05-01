require 'xommelier/xml/schema/group'

module Xommelier
  module Xml
    class Schema
      class NamedGroup < Group
        attr_reader :name

        def initialize(name, options = {}, &block)
          @name = name
          super(options, &block)
        end

        def to_reference
          self
        end

        def to_field_names
          fields.keys
        end
      end
    end
  end
end
