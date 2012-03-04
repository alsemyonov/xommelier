require 'xommelier/atom'

module Xommelier
  module Atom
    module Thread
      include Xommelier::Xml

      xmlns 'http://purl.org/syndication/thread/1.0', as: :thr

      class InReplyTo < Xml::Element
        element_name 'in-reply-to'
        #method_name :in_reply_to

        attribute :href

        may do
          attribute :href, type: Uri
          attribute :type, type: String
          attribute :source
        end
      end
    end

    # Extends Atom elements
    class Entry
      may do
        element :in_reply_to, ns: Thread.xmlns
        element :total, type: Integer, ns: Thread.xmlns
      end
    end

    class Link
      may do
        attribute :count, type: Integer, ns: Thread.xmlns
      end
    end
  end
end
