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

    #namespace 'http://purl.org/syndication/thread/1.0', as: :thr do
      #element :in_reply_to, as: 'in-reply-to' do
        #attribute :ref

        #may do
          #attribute :href, type: Uri
          #attribute :type, type: String
          #attribute :source
        #end
      #end

      #ns.atom.element :entry do
        #element :in_reply_to, ns: ns.thr
        #element :total, type: Integer, ns: ns.thr
      #end

      #ns.atom.element :link, values: [:replies] do
        #ns.thr.attribute :count, type: Integer
      #end
    #end
  end
end
