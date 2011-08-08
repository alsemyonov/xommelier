require 'xommelier'
require 'xommelier/xml/class_methods'
require 'active_support/concern'

module Xommelier
  module Xml
    extend ActiveSupport::Concern

    autoload :Namespace,  'xommelier/xml/namespace'
    autoload :Element,    'xommelier/xml/element'
    autoload :Attribute,  'xommelier/xml/attribute'
  end
end
