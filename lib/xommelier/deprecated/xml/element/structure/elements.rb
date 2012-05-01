module Xommelier
  module Xml
    class Element
      module Structure
        module ClassMethods
          # Defines containing element
          # @example
          #   element :author, type: Xommelier::Atom::Person
          def element(name, options = {})
            options[:element_name] = options.delete(:as) { name }
            options[:ns] ||= if options[:type].try(:<, Xml::Element)
                               options[:ns] = options[:type].xmlns
                             else
                               xmlns
                             end
            elements[name] = DEFAULT_ELEMENT_OPTIONS.merge(options)
            define_element_accessors(name)
          end

          def any(&block)
            with_options(count: :any)  { |any|  any.instance_eval(&block)   }
          end

          def many(&block)
            with_options(count: :many) { |many| many.instance_eval(&block)  }
          end

          def may(&block)
            with_options(count: :may)  { |may|  may.instance_eval(&block)   }
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
                  args.flatten.each_with_index do |object, index|
                    write_element(name, object, index)
                  end
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

        def read_element(name, index = nil)
          index ? @elements[name.to_sym][index] : @elements[name.to_sym]
        end

        def write_element(name, value, index = nil)
          type = element_options(name)[:type]
          unless value.is_a?(type)
            value = if (type < Xommelier::Xml::Element) && !value.is_a?(Nokogiri::XML::Node)
                      type.new(value)
                    else
                      type.from_xommelier(value)
                    end
          end
          if index
            @elements[name.to_sym] ||= []
            @elements[name.to_sym][index] = value
          else
            @elements[name.to_sym] = value
          end
        end

        def remove_element(name)
          @elements.delete(name.to_sym)
        end
      end
    end
  end
end
