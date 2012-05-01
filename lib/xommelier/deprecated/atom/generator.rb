require 'xommelier/atom'

module Xommelier
  module Atom
    class Generator < Xml::Element
      may do
        attribute :uri, type: URI
        attribute :version
      end

      text
    end
  end
end
