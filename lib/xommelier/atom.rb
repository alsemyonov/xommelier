require 'xommelier/xml'

module Xommelier
  module Atom
    include Xommelier::Xml

    class NCName < String
      FORMAT = /^[^:]+$/
    end

    class MediaType < String
      FORMAT = %r{^.+/.+$}
    end

    class Uri < String
    end

    class Language < String
    end

    namespace 'http://www.w3.org/2005/Atom', as: :atom do
      attribute :type, values: [:text, :html, :xhtml]

      element :feed, root: true do
        element :id
        element :title
        element :updated

        may do
          element :generator
          element :icon
          element :logo
          element :rights
          element :subtitle
        end

        any do
          element :author
          element :category
          element :contributor
          element :link
          element :entry
        end
      end

      element :entry, root: true do
        element :id
        element :title
        element :updated

        may do
          element :content
          element :published
          element :rights
          element :source
          element :summary
        end

        any do
          element :author
          element :category
          element :contributor
          element :link
        end
      end

      element :author, :contributor do
        element :name

        may do
          element :email
          element :uri
        end
      end

      element :category do
        attribute :term

        may do
          attribute :scheme, type: Uri
          attribute :label
        end
      end

      element :generator do
        may do
          attribute :uri, type: Uri
          attribute :version
        end
      end

      element :icon, :logo, type: Uri

      element :id, unique: true

      element :link do
        attribute :href, type: Uri

        may do
          attribute :rel, type: NCName, values: [:alternate, :related, :self, :enclosure, :via]
          attribute :type, type: MediaType
          attribute :hreflang, type: Language
          attribute :title
          attribute :length
        end
      end

      element :published, :updated, type: Date

      element :source do
        may do
          element :generator, :icon, :id, :logo, :rights, :subtitle, :title, :updated
        end
        any do
          element :author, :category, :contributor, :link
        end
      end
    end

    namespace 'http://purl.org/syndication/thread/1.0', as: :thr do
      element :in_reply_to, as: 'in-reply-to' do
        attribute :ref

        may do
          attribute :href, type: Uri
          attribute :type, type: MediaType
          attribute :source
        end
      end

      ns.atom.element :entry do
        element :in_reply_to, ns: ns.thr
        element :total, type: Integer, ns: ns.thr
      end

      ns.atom.element :link, values: [:replies] do
        ns.thr.attribute :count, type: Integer
      end
    end
  end
end
