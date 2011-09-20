module Xommelier
  module Xml
    class Element
      module Structure
        module ClassMethods
          # Defines containing element
          # @example
          #   element :author, class_name: 'Xommelier::Atom::Person'
          def element(name, options = {})
            options[:element_name] = name
            elements[name] = DEFAULT_ELEMENT_OPTIONS.merge(options)
            define_element_accessors(name)
          end

          def any(&block)
            with_options(count: :any) do |any|
              any.instance_eval(&block)
            end
          end

          def many(&block)
            with_options(count: :many) do |many|
              many.instance_eval(&block)
            end
          end

          def may(&block)
            with_options(count: :may) do |may|
              may.instance_eval(&block)
            end
          end

          protected

          def define_element_accessors(name)
            element_options = elements[name]
            case element_options[:count]
            when :one, :may
              name = name.to_sym
              define_method(name) do |*args|
                if args[0]
                  write_element(name, args[0])
                end
                read_element(name)
              end
              alias_method "#{name}=", name
            when :many, :any
              plural = name.to_s.pluralize.to_sym
              element_options[:plural] = plural

              define_method(plural) do |*args|
                if args.any?
                  @elements[name] = args.flatten
                end
                @elements[name] ||= []
              end
              alias_method "#{plural}=", plural

              unless plural == name
                define_method(name) do |*args|
                  if args[0]
                    send(plural, [args[0]])
                  else
                    send(plural)[0]
                  end
                end
                alias_method "#{name}=", name
              end
            end
          end
        end

        protected

        def element_options(name)
          self.class.elements[name.to_sym]
        end

        def read_element(name)
          @elements[name.to_sym]
        end

        def write_element(name, value)
          type = element_options(name)[:type]
          unless value.is_a?(type)
            value = if (type < Xommelier::Xml::Element) && !value.is_a?(Nokogiri::XML::Node)
                      type.new(value)
                    else
                      type.from_xommelier(value)
                    end
          end
          @elements[name.to_sym] = value
        end

        def remove_element(name)
          @elements.delete(name.to_sym)
        end
      end
    end
  end
end
