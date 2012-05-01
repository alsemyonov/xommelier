require 'xommelier/builder'
require 'active_support/core_ext/hash/except'

module Xommelier
  class Builder
    class Base
      class Code < String
        def inspect
          self
        end
      end

      class_attribute :method_name

      class << self
        def parse(node, options)
          options[:builder].send(:parse_node, node, options)
        end

        def wrapper(element, options)
          class_name = element.name.classify
          "Xommelier::Builder::#{class_name}".constantize.new(element, options)
        rescue NameError => e
          $stderr.puts e.message
          nil
        end
      end

      attr_reader :element, :options, :prefix
      def initialize(element, options = {})
        @element = element
        @prefix = options.delete(:prefix).try(:to_sym) if options.key?(:prefix)
        @options = {indent: 1}.merge(options)
        extract_annotation!
      end

      def to_ruby
        method { pass }
      end

      def to_options
        method_options
      end

      protected

      def first_element_child
        element.first_element_child
      end

      def extract_annotation!(child = first_element_child)
        if child.try(:name) == 'annotation'
          doc = child.at_xpath('xs:documentation')
          @documentation = if doc.content.present?
                             child.at_xpath('xs:documentation').content.chomp.strip
                           elsif doc['source']
                             "{#{doc['source']}}"
                           end.gsub(/^\s*/, '# ')
          child.remove
        end
      end

      def pass
        element_children.inject([]) do |result, child|
          result << self.class.parse(child, options.merge(prefix: prefix))
        end.join("\n")
      end

      def element_children
        (@removed_children || []) + @element.element_children
      end

      def indent
        @options[:indent]
      end

      def indented(code, indent=self.indent)
        indentation = ' ' * indent * 2
        code.to_s.split(/\n+/).map do |string|
          if string.present?
            "#{indentation}#{string}"
          end
        end.compact.join("\n")
      end

      def documentation
        if @documentation.present?
          indented(@documentation) << "\n"
        else
          ''
        end
      end

      def method(*arguments)
        arguments = [format_arguments(arguments), format_options(method_options)].compact.join(', ')
        documentation <<
        indented([method_name, arguments].compact.join(' ')).tap do |result|
          if block_given?
            block = yield.presence
            if block
              result << (result =~ /\ $/ ? '' : ' ') << "do\n"
              result << indented(block, indent) << "\n"
              result << indented("end")
            end
          end
          result << "\n"
        end
      end

      COMMON_ATTRIBUTES = %w(minOccurs maxOccurs type ref use id fixed)
      def method_options
        {}.tap do |opts|
          opts[:id] = element['id'].to_sym if element['id']
          opts[:type] = deprefix(element['type']) if element['type']
          opts[:ref] = deprefix(element['ref']) if element['ref']
          opts[:min] = element['minOccurs'].to_i if element['minOccurs']
          opts[:fixed] = Code.new(element['fixed']) if element['fixed']
          if element['maxOccurs']
            opts[:max] = if element['maxOccurs'] == 'unbounded'
                           :unbounded
                         else
                           element['maxOccurs'].to_i
                         end
          end
          if element['use']
            opts[:required] = case element['use']
                              when 'required'
                                true
                              when 'optional'
                                false
                              else
                                element['use']
                              end
          end
          uncommon_opts = element.attributes.except(*COMMON_ATTRIBUTES).inject({}) do |result, (key, attr)|
            result[key] = attr.value
            result
          end
          opts.merge!(uncommon_opts)
        end
      end

      def format_arguments(arguments)
        arguments.compact.map(&:inspect).join(', ').presence
      end

      def format_options(options)
        string = options.map do |key, value|
          "#{key}: #{value.is_a?(Hash) ? "{#{format_options(value)}}" : value.inspect}"
        end.compact.join(', ').presence
      end

      def deprefix(value)
        if value.is_a?(String) || value.is_a?(Symbol)
          if value.to_s =~ /^(.+):(.+)$/
            if $1.to_sym == prefix
                           $2.to_sym
                         else
                           Code.new("ns.#{value.to_s.gsub(':', '.')}")
                         end
          else
            value.to_sym
          end
          #Code.new("ref('#{value}')")
        else
          value
        end
      end

      def options_from(element_name)
        remove_child(element_name) do |child|
          child.to_options
        end || {}
      end

      def remove_child(element_name)
        child = first_element_child
        if child.try(:name) == element_name
          child = self.class.wrapper(child, options)
          yield(child).tap do
            @removed_children ||= []
            @removed_children += child.element.element_children
            child.element.remove
          end
        end
      end
    end
  end
end
