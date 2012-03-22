require 'xommelier'
require 'active_support/dependencies/autoload'
require 'active_support/concern'

module Xommelier
  module Xml
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    DEFAULT_NS = 'http://www.w3.org/XML/1998/namespace'

    included do
      instance_variable_set :@_xmlns, nil
    end

    autoload :Attributes
    autoload :AttributesProxy
    autoload :Element
    autoload :Field
    autoload :Namespace
    autoload :Node
    autoload :Serialization
  end
end

require 'xommelier/xml/class_methods'
