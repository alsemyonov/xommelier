require 'xommelier'
require 'xommelier/xml/class_methods'
require 'active_support/concern'

module Xommelier
  module Xml
    extend ActiveSupport::Concern

    DEFAULT_NS = 'http://www.w3.org/XML/1998/namespace'

    included do
      instance_variable_set :@_xmlns, nil
    end

    autoload :Namespace,  'xommelier/xml/namespace'
    autoload :Element,    'xommelier/xml/element'

    extend ClassMethods
    xmlns DEFAULT_NS, as: :xml

    module CommonAttributes
      def self.included(base)
        base.attribute :lang, ns: Xml.xmlns
        base.attribute :base, type: Uri, ns: Xml.xmlns
      end
    end
  end
end
