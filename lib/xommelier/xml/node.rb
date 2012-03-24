require 'xommelier/xml'
require 'xommelier/xml/serialization'
require 'xommelier/xml/attributes'

module Xommelier
  module Xml
    class Node
      attr_accessor :options

      def initialize(contents = nil, options = {})
        self.options  = options
        self.contents = contents
      end
    end

    Node.class_eval do
      include Serialization
      include Attributes
    end
  end
end
