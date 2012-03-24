require 'xommelier/atom'

module Xommelier
  module Atom
    class Generator < Xml::Element
      may do
        attribute :uri, type: Uri
        attribute :version
      end

      text
    end
  end
end
