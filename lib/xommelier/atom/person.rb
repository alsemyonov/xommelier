require 'xommelier/atom'

module Xommelier
  module Atom
    class Person < Xml::Element
      element :name

      may do
        element :email
        element :uri, type: Uri
      end
    end
  end
end
