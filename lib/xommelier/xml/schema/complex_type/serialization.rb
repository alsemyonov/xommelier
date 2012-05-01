require 'xommelier/xml/schema/complex_type'
require 'active_support/concern'
require 'active_support/core_ext/module/delegation'

module Xommelier
  module Xml
    class Schema
      module ComplexType
        module Serialization
          extend ActiveSupport::Concern

          included do
            include Fields::Attributes
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

          attr_writer :element_name
          def element_name
            @element_name ||= self.class.name.demodulize.underscore.dasherize#.tap { |elname| puts name, elname }
          end

          module ClassMethods
            def deserialize(value)
              #puts self.inspect, content?, value, base
              if content?
                base.deserialize(value)
              else
                value
              end
            end

            def to_model
              self
            end

            def to_key
              nokogiri_xml.document.root.name
            end
          end
        end
      end
    end
  end
end
