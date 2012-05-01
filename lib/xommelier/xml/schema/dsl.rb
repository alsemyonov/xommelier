require 'xommelier/xml/schema'
require 'active_support/core_ext/module/delegation'

module Xommelier
  module Xml
    class Schema
      module DSL
        def self.extended(mod)
          mod.singleton_class.module_eval do
            delegate :namespace, :xmlns, :ns, :uses, :import,
              :element, :elements,
              :attribute, :attribute_group,
              :complex_type, :simple_type,
              to: :schema
          end
          super
        end

        def schema(name=nil, options={}, &block)
          @schema ||= begin
                        name ||= self.name.underscore
                        Schema.new(name, options.merge(module: self), &block)
                      end
        end
      end
    end
  end
end
