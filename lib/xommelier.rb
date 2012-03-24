require 'xommelier/version'
require 'xommelier/core_ext'

module Xommelier
  autoload :Atom,       'xommelier/atom'
  autoload :OpenSearch, 'xommelier/open_search'
  autoload :XSD,        'xommelier/xsd'
end

require 'xommelier/xml'
