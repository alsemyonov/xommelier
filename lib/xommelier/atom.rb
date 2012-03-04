require 'xommelier/xml'

module Xommelier
  module Atom
    include Xommelier::Xml

    xmlns 'http://www.w3.org/2005/Atom', as: :atom
    #roots :Feed, :Entry

    # Elements
    autoload :Link,      'xommelier/atom/link'
    autoload :Person,    'xommelier/atom/person'
    autoload :Category,  'xommelier/atom/category'
    autoload :Generator, 'xommelier/atom/generator'
    autoload :Source,    'xommelier/atom/source'
    autoload :Feed,      'xommelier/atom/feed'
    autoload :Entry,     'xommelier/atom/entry'

    # Extensions
    autoload :Thread,    'xommelier/atom/thread'
  end
end
