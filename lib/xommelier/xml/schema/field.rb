require 'xommelier/xml/schema'
require 'active_support/inflector'
require 'active_support/inflections'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'active_support/deprecation'
require 'xommelier/schemas/xml_schema/string'

module Xommelier
  module Xml
    class Schema
      class Field
        class_attribute :default_options
        self.default_options = {
          default: nil,
          fixed: nil,
          min: 1,
          max: 1
        }

        attr_reader :name, :type, :default, :xmlns, :node_type, :method_name, :plural_method_name
        attr_accessor :schema
        alias getter method_name
        alias plural_getter plural_method_name

        def initialize(name, options = {})
          @name = name.to_s
          @options = {}
          self.options = default_options.merge(options)
        end

        def options(options={})
          if options[:method_name]
            @method_name = options.delete(:method_name)
          end
          @method_name ||= name.to_sym

          if options[:plural_method_name]
            @plural_method_name = options.delete(:plural_method_name).to_sym
          end
          @plural_method_name ||= method_name.to_s.pluralize.to_sym

          @node_type = options.delete(:node_type) if options[:node_type]
          @default   = options.delete(:default)   if options[:default]
          @xmlns     = options.delete(:xmlns)     if options[:xmlns]
          self.type  = options.delete(:type)      if options[:type]
          if options.key?(:count)
            count = options.delete(:count)
            case count
            when :one
              options[:min] = 1
              options[:max] = 1
            when :may
              options[:min] = 0
              options[:max] = 1
            when :any
              options[:min] = 0
              options[:max] = :unbounded
            when :many
              options[:min] = 1
              options[:max] = :unbounded
            end
            ActiveSupport::Deprecation.warn("{count: #{count}} is deprecated. Use {min: #{options[:min]}, max: #{options[:max]}} instead.")
          end
          @options.merge!(options)
          @options
        end
        alias options= options

        def type
          @type ||= Schemas::XmlSchema::String
        end

        def type=(type)
          @xmlns ||= type.xmlns if type.respond_to?(:xmlns)
          @type = type
        end

        def setter;           :"#{method_name}=";         end
        def presence;         :"#{method_name}?";         end
        def plural_setter;    :"#{plural_method_name}=";  end
        def plural_presence;  :"#{plural_method_name}?";  end

        def plural?
          options[:max] == :unbounded
        end

        def finder_method
          plural? ? :xpath : :at_xpath
        end

        def xpath
          case node_type
          when :element
            if xmlns.try(:prefix)
              ["#{xmlns.prefix}:#{name}", xmlns.to_hash]
            else
              ["#{name}"]
            end
          when :attribute
            ["@#{name}"]
          when :content
            ["text()"]
          end
        end

        def get(xml_node)
          node = xml_node.at_xpath(*xpath, xmlns.to_hash)
          #puts xml_node.to_xml, inspect, xpath, node
          node = node.content if node.is_a?(Nokogiri::XML::Node)
          type.deserialize(node)
        end

        def set(xml_node, value)
          #puts self.inspect, xml_node, value
          value = type.new(value) unless value.is_a?(type)
          case node_type
          when :attribute
            xml_node[name] = value.to_xml
          when :element
            child = xml_node.document.create_element(name, value.to_xml)
            xml_node.add_child(child)
          when :content
            xml_node.content = value.to_xml
          end
        end

        def to_reference
          {name => self}
        end

        def to_field_names
          [name]
        end
      end
    end
  end
end
