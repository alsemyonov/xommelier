require 'xommelier/xml/schema'

module Xommelier
  module Xml
    class Schema
      module Referenced
        def referenced(*methods)
          methods.each do |method|
            define_method(method) do |*args, &block|
              options = args.extract_options!
              name = args.shift
              if options[:ref]
                raise DefRefError.new(options) if name
                ref = options.delete(:ref)
                case ref
                when ComplexType::Field
                  parent = ref
                  name = parent.name.to_sym
                when Symbol, String
                  name = ref.to_sym
                  parent = schema.send(method, name, {})
                else
                  raise "Undefined reference: #{ref.inspect}"
                end
                if options.any?
                  super(name, options.merge(type: ref), &block)
                else
                  fields << parent.to_reference
                  if is_a?(Module)
                    include parent.generated_attribute_methods
                    #define_attribute_methods(parent.to_field_names)
                  end
                end
              else
                super(name, options, &block)
              end
            end
          end
        end
      end
    end
  end
end
