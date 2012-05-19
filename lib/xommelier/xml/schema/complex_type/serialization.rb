require 'xommelier/xml/proxy'
require 'xommelier/xml/schema/complex_type'
require 'active_support/concern'
require 'active_support/core_ext/module/delegation'

module Xommelier
  module Xml
    class Schema
      module ComplexType
        module Serialization
          extend ActiveSupport::Concern

          module ClassMethods
            def deserialize(value)
              #puts self.inspect, content?, value, base
              if content?
                base.deserialize(value)
              else
                value
              end
            end
          end

          # @return [Type]
          def initialize(*args)
            super(*args)
            @attributes = Xml::Proxy.new(xml_node, self.class)
          end

          def element_name
            @element_name ||= self.class.name.demodulize.underscore.dasherize
          end
          attr_writer :element_name

          def to_model
            self
          end

          def to_key
            nokogiri_xml.document.root.name
          end

          protected

          attr_reader :attributes
          def attributes=(attrs)
            @attributes.replace(attrs)
          end

          def write_attributes(attributes)
            @attributes.merge!(attributes)
          end

          def read_attribute(name)
            @attributes[name]
          end
          alias attribute read_attribute

          def write_attribute(name, value)
            @attributes[name] = value
          end
          alias attribute= write_attribute

          def attribute?(name)
            @attributes[name].present?
          end

          def reset_attribute(name)
            @attributes.reset(name)
          end

          attr_writer :xml_node
          def xml_node
            @xml_node ||=
              begin
                doc = Nokogiri::XML::Document.new
                doc.encoding = 'utf-8'
                doc.create_element(element_name).tap do |element|
                  doc.add_child(element)
                  element.default_namespace = namespace
                end
              end
          end

          delegate :inspect, to: :to_xml

          def xml_document
            xml_node.document
          end

          def serialize
            xml_document.to_xml
          end
        end
      end
    end
  end
end
