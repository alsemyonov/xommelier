require 'xommelier/xml'

module Xommelier
  # Implements The Atom Syndication Format
  # See RFC 4287 {http://tools.ietf.org/html/rfc4287.html}
  module Atom
    include Xommelier::Xml

    xmlns 'http://www.w3.org/2005/Atom', as: :atom

    # Elements
    autoload :Link,      'xommelier/atom/link'
    autoload :Person,    'xommelier/atom/person'
    autoload :Category,  'xommelier/atom/category'
    autoload :Content,   'xommelier/atom/content'
    autoload :Generator, 'xommelier/atom/generator'
    autoload :Source,    'xommelier/atom/source'
    autoload :Feed,      'xommelier/atom/feed'
    autoload :Entry,     'xommelier/atom/entry'

    # Common extensions
    autoload :LinksExtension, 'xommelier/atom/links_extension'

    # Extensions
    autoload :Threading, 'xommelier/atom/threading'
    autoload :History,   'xommelier/atom/history'
  end
end
