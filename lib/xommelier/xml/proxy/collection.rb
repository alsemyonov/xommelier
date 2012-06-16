require 'xommelier/xml/proxy'

module Xommelier
  module Xml
    class Proxy
      class Collection < Delegator
        def initialize(node, field)
          super(node)
          @field = field
        end

        def __getobj__
          items
        end

        def __setobj__(node)
          @parent = node
        end

        def each(&block)
          items.each(&block)
        end

        include Enumerable

        def replace(array)
          xml_nodes.remove
          array.each do |item|
            self << item
          end
        end

        def <<(value)
          @parent.add_child(
            @parent.document.create_element(
              field.name,
              serialize_value(value).to_xml
            )
          )
        end

        protected

        def serialize_value(value)
          if value.is_a?(@field.type)
            value
          else
            value = @field.type.new(value)
          end
        end

        def xml_nodes
          @parent.xpath(@field.xpath, @field.xmlns.to_hash)
        end

        def items
          xml_nodes.map do |node|
            @field.type.new(node.content)
          end
        end
      end
    end
  end
end
