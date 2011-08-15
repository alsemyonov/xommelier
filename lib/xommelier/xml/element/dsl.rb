require 'xommelier/xml/element'

module Xommelier
  module Xml
    class Element
      module DSL
        def element(name, options = {})
          self.elements[name] = DEFAULT_ELEMENT_OPTIONS.merge(options)
          define_element_accessors(name)
        end

        def attribute(name, options = {})
          self.attributes[name] = DEFAULT_OPTIONS.merge(options)
          define_attribute_accessors(name)
        end

        def text(options = {})
          define_text_accessors
        end

        private

        def define_text_accessors
          define_method(:text)  {         @text ||= ''  }
          define_method(:text=) { |value| @text = value }
        end

        def define_element_accessors(name)
          case elements[name][:count]
          when :one, :may
            define_method(name)       {         @elements[name]         }
            define_method("#{name}=") { |value| @elements[name] = value }
          when :many
            define_method(name)       {
              @elements[name] ||= []
            }
            define_method("#{name}=") do |value|
              @elements[name] ||= []
              @elements[name] += Array(value)
            end
          end
        end

        def define_attribute_accessors(name)
          define_method(name)       {         @attributes[name]         }
          define_method("#{name}=") { |value| @attributes[name] = value }
        end
      end
    end
  end
end
