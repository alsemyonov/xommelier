require 'xommelier/atom'

module Xommelier
  module Atom
    class Category < Xml::Element
      attribute :term

      may do
        attribute :scheme, type: Uri
        attribute :label
      end
    end
  end
end
