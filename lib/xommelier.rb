require 'xommelier/version'

module Xommelier
  class DeserializationError < TypeError
    def initialize(type, value)
      super("Class #{value.class} cannot be deserialized to #{type.name}, provided value is: #{value.inspect}")
    end
  end

  class DefRefError < ArgumentError
    def initialize(options)
      super("Attribute Group cannot contain both name and ref, but passed options is #{options.inspect}")
    end
  end

  class ContentTypeError < TypeError
    def initialize(type, new)
      super("Type #{type.name} is already defined as #{type.options[:_type]}, it cannot be #{new} also")
    end
  end

  class ComplexContentTypeError < TypeError
    def initialize(type, new)
      super("Content of #{type.name} is already defined as #{type.options[:_content]}, it cannot be #{new} also")
    end
  end
end

require 'xommelier/utils'
require 'xommelier/core_ext'
require 'xommelier/xml'
require 'xommelier/xml/schema'
