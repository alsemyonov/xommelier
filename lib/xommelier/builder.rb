require 'xommelier'
require 'nokogiri'
require 'set'

module Xommelier
  class Builder
    attr_reader :errors

    def initialize(schema_file)
      @xml = Nokogiri::XML(schema_file.read)
      @indent = 4
      @errors = Set.new
    end

    def xmlns
      @xmlns ||= @xml.root.attributes['targetNamespace'].value
    end

    def prefix
      @prefix ||= @xml.namespaces.key(xmlns).gsub(/^xmlns:/, '')
    end

    def module_name
      prefix.classify
    end

    def documentation
      output(comment(@xml.at_xpath('/xs:schema/xs:annotation/xs:documentation').content.chomp.strip)) << "\n"
    end

    def root
      @xml.root
    end

    def parse_node(node)
      method_name = node.name.underscore
      if respond_to?(method_name)
        send(method_name, node)
      else
        @errors << "No conversion for <#{node.namespace.href}##{node.name}/> provided"
        output(comment(node.to_xml))
      end
    end

    def parse_children(node)
      node.element_children.inject([]) do |result, child|
        result << parse_node(child)
      end.join("\n")
    end

    def annotation(node)
      unless node.parent.first_element_child == node
        output(comment(node.at_xpath('xs:documentation').content.chomp.strip))
      end
    end

    def comment(text)
      text.gsub(/^\s*/, '# ')
    end

    def import(node)
      output method(:import, node['namespace'])
    end

    def element(node)
      output method(:element, node['name'], options(type: node['type']))
    end

    def attribute(node)
      options = {}
      options['type'] = node['type'] if node['type']
      string = method(:attribute, node['name'], options(options))
      output(string) { parse_children(node) }
    end

    def complex_type(node)
      output(method(:complex, node['name'])) do
        parse_children(node)
      end
    end

    def attribute_group(node)
      string = method(:attributes, deprefix(node['name'].presence || node['ref']))
      output(string) do
        parse_children(node)
      end
    end

    def simple_type(node)
      output(method(:simple, node['name'])) do
        parse_children(node)
      end
    end

    def extension(node)
      output(method(:extends, node['base'])) do
        parse_children(node)
      end
    end

    def restriction(node)
      options = {on: node['base']}
      child = node.first_element_child
      if child.try(:name) == 'pattern'
        options[:pattern] = child['value']
        child.remove
      elsif child.try(:name) == 'enumeration'
        options[:in] = node.xpath('./xs:enumeration').inject([]) do |result, child|
          result << child['value']
          child.remove
          result
        end
      end
      output(method(:restricts, nil, options(options))) do
        parse_children(node)
      end
    end

    def simple_content(node)
      output(method(:simple_content)) do
        parse_children(node)
      end
    end

    def choice(node)
      output(method(:choice, nil, options(occurs(node)))) do
        parse_children(node)
      end
    end

    def sequence(node)
      output(method(:sequence)) do
        parse_children(node)
      end
    end

    def schema(node)
      documentation <<
        output(method(:xmlns, xmlns, options(as: prefix))) do
          parse_children(node)
        end
    end

    def any(node)
      options = {}
      options[:ns] = node['namespace'] if node['namespace']
      options.merge(occurs(node))
      output(method(:any, nil, options(options)))
    end

    def any_attribute(node)
      options = {}
      options[:ns] = node['namespace'] if node['namespace']
      output(method(:any_attributes, nil, options(options)))
    end

    def occurs(node)
      {}.tap do |options|
        options[:min] = node['minOccurs'].to_i if node['minOccurs']
        if node['maxOccurs'] == 'unbounded'
          options[:max] = :unbounded
        elsif node['maxOccurs']
          options[:max] = node['maxOccurs'].to_i
        end
      end
    end

    def method(name, *arguments)
      main = arguments.shift
      if main
        arguments.unshift(main.to_sym.inspect)
      end
      "#{name} #{arguments.compact.join(', ')}"
    end

    def options(hash)
      string = hash.map do |key, value|
        "#{key}: #{deprefix(value).inspect}" if value
      end.compact.join(', ').presence
    end

    def deprefix(value)
      if value.is_a?(String) || value.is_a?(Symbol)
        value = value.to_s
        if value =~ /^#{prefix}\:/
          value.gsub(/^#{prefix}\:/, '').to_sym
        #elsif value =~ /:/
          #value.gsub(/^(.+):/, 'ns.\1.')
        else
          value
        end
      else
        value
      end
    end

    def output(text, indent=2)
      old_indent, @indent = @indent, indent
      text.to_s.split("\n").map { |line| "#{' ' * indent}#{line}" }.compact.join("\n").tap do |result|
        if block_given?
          block = output(yield, indent)
          if block.present?
            result << " do\n" << block << output("\nend")
          end
        end
        @indent = old_indent
      end
    end
  end
end
