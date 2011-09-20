require 'xommelier/xml/element'
require 'active_support/concern'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/with_options'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

module Xommelier
  module Xml
    class Element
      module Structure
        extend ActiveSupport::Concern

        included do
          class_attribute :elements, :attributes
          attr_writer :element_name

          self.elements = {}
          self.attributes = {}

          class << self
            include SingletonClassMethods
          end

          delegate :xmlns, to: 'self.class'
        end

        module SingletonClassMethods
          def containing_module
            @containing_module ||= ("::#{name.gsub(/::[^:]+$/, '')}").constantize
          end

          def xmlns(value = nil)
            if value
              @xmlns = case value
                       when Module
                         value.xmlns
                       else
                         value
                       end
            end
            @xmlns ||= find_namespace
          end
          alias_method :xmlns=, :xmlns

          def element_name(element_name = nil)
            @element_name = element_name if element_name
            @element_name ||= find_element_name
          end

          private

          def find_namespace
            if self == containing_module
              Xommelier::Xml::DEFAULT_NS
            else
              containing_module.xmlns
            end
          end

          def find_element_name
            name.demodulize.underscore.dasherize
          end
        end

        module ClassMethods
          def inherited(child)
            child.elements    = elements.dup
            child.attributes  = attributes.dup
          end

          def root
            #xmlns.roots << self
          end
        end

        protected

        def element_name(value = nil)
          if value
            @element_name = value
          end
          @element_name ||= self.class.element_name
        end
      end
    end
  end
end

require 'xommelier/xml/element/structure/attributes'
require 'xommelier/xml/element/structure/elements'
require 'xommelier/xml/element/structure/text'
