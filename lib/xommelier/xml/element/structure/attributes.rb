module Xommelier
  module Xml
    class Element
      module Structure
        module ClassMethods
          # Defines containing attribute
          def attribute(name, options = {})
            attributes[name] = DEFAULT_OPTIONS.merge(options)
            define_attribute_accessors(name)
          end

          protected

          def define_attribute_accessors(name)
            define_method(name) do |*args|
              if args[0]
                write_attribute(name.to_s, args[0])
              end
              read_attribute(name)
            end
            alias_method "#{name}=", name
          end
        end

        protected

        def attribute_options(name)
          self.class.attributes[name.to_sym]
        end

        def read_attribute(name)
          @attributes[name.to_sym]
        end

        def write_attribute(name, value)
          type = attribute_options(name)[:type]
          value = type.from_xommelier(value) unless value.is_a?(type)
          @attributes[name.to_sym] = value
        end

        def remove_attribute(name)
          @attributes.delete(name.to_sym)
        end
      end
    end
  end
end
