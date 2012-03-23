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
      @prefix ||= @xml.root.namespaces.key(xmlns).gsub(/^xmlns:/, '')
    end

    def module_name
      prefix.classify
    end

    def to_ruby
      %(module Xommelier\n#{parse_node(@xml.root)}end)
    end

    protected

    def parse_node(node, options = {})
      class_name = node.name.classify
      method_name = node.name.underscore
      if self.class.const_defined?(class_name)
        "#{self.class.name}::#{node.name.classify}".constantize.new(node, {builder: self, prefix: prefix}.merge(options)).to_ruby
      else
        @errors << "No conversion for <#{node.namespace.href}##{node.name}/> provided"
        comment(node.to_xml)
      end
    end

    def comment(text)
      text.gsub(/^\s*/, '# ')
    end
  end
end

require 'xommelier/builder/annotation'
require 'xommelier/builder/any'
require 'xommelier/builder/any_attribute'
require 'xommelier/builder/attribute'
require 'xommelier/builder/attribute_group'
require 'xommelier/builder/choice'
require 'xommelier/builder/complex_content'
require 'xommelier/builder/complex_type'
require 'xommelier/builder/element'
require 'xommelier/builder/extension'
require 'xommelier/builder/group'
require 'xommelier/builder/import'
require 'xommelier/builder/key'
require 'xommelier/builder/list'
require 'xommelier/builder/max_inclusive'
require 'xommelier/builder/max_length'
require 'xommelier/builder/min_inclusive'
require 'xommelier/builder/min_length'
require 'xommelier/builder/pattern'
require 'xommelier/builder/restriction'
require 'xommelier/builder/schema'
require 'xommelier/builder/sequence'
require 'xommelier/builder/simple_content'
require 'xommelier/builder/simple_type'
require 'xommelier/builder/union'
require 'xommelier/builder/white_space'
