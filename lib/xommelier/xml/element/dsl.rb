require 'xommelier/xml/element'

module Xommelier
  module Xml
    class Element
      module DSL
        def element(name, options = {})
          self.elements[name] = DEFAULT_OPTIONS.merge(options)
          define_element_accessors(name)
        end

        def attribute(name, options = {})
          self.attributes[name] = DEFAULT_OPTIONS.merge(options)
          define_attribute_accessors(name)
        end

        def text(options = {})
        end

        private

        def define_element_accessors(name)
          define_method(name)       {         @elements[name]         }
          define_method("#{name}=") { |value| @elements[name] = value }
        end

        def define_attribute_accessors(name)
          define_method(name)       {         @attributes[name]         }
          define_method("#{name}=") { |value| @attributes[name] = value }
        end
      end
    end
  end
end
