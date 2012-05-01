require 'xommelier/atom'

module Xommelier
  module Atom
    class Link < Xml::Element
      attribute :href, type: URI

      may do
        attribute :rel#, type: Enum(:alternate, :related, :self, :enclosure, :via)
        attribute :type
        attribute :hreflang
        attribute :title
        attribute :length, type: Integer
      end
    end
  end
end
