require 'xommelier/version'
require 'xommelier/core_ext'

module Xommelier
  autoload :Atom,       'xommelier/atom'
  autoload :OpenSearch, 'xommelier/open_search'
  autoload :OPML, 'xommelier/opml'
  autoload :RSS, 'xommelier/rss'

  # Standard Xommelier Error
  class Error < ::StandardError
  end

  # This error raised when there are no schema provided but {Xommelier::Xml::Element#valid?} called.
  class NoSchemaError < Error
    def initialize(object)
      super("Cannot validate #{object} because no schema provided for validation.")
    end
  end

  # Typecasting error
  class TypeError < Error
    def initialize(object, type)
      super("Cannot typecast #{object.inspect} to #{type}")
    end
  end
end

require 'xommelier/xml'
