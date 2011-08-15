require 'xommelier'
require 'xommelier/xml/class_methods'
require 'active_support/concern'

module Xommelier
  module Xml
    extend ActiveSupport::Concern

    Infinity = 1.0 / 0

    included do
      instance_variable_set :@_xmlns, nil
    end

    autoload :Namespace,  'xommelier/xml/namespace'
    autoload :Element,    'xommelier/xml/element'
  end
end
