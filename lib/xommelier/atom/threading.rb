require 'xommelier/atom'

module Xommelier
  module Atom
    module Threading
      include Xommelier::Xml

      xmlns 'http://purl.org/syndication/thread/1.0', as: :thr

      class InReplyTo < Xml::Element
        element_name 'in-reply-to'

        attribute :ref

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
        element :in_reply_to, type: Threading::InReplyTo, as: Threading::InReplyTo.element_name
        element :total, type: Integer, ns: Threading.xmlns
      end
    end

    class Link
      may do
        attribute :count, type: Integer, ns: Threading.xmlns
        attribute :updated, type: Time, ns: Threading.xmlns
      end
    end
  end
end
