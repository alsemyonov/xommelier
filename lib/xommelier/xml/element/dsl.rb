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

        def define_element_accessors(name)
          case elements[name][:count]
          when :one, :may
            define_method(name) do |*args|
              if args[0]
                write_element(name, args[0])
              end
              read_element(name)
            end
            alias_method "#{name}=", name
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
          define_method(name) do |*args|
            if args[0]
              write_attribute(name, args[0])
            end
            read_attribute(name)
          end
          alias_method "#{name}=", name
        end

        def define_text_accessors
          define_method(:text) do |*args|
            if args[0]
              write_text(args[0])
            end
            read_text
          end
          alias_method :text=, :text
        end
      end
    end
  end
end
