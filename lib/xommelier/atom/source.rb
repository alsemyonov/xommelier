require 'xommelier/atom'

module Xommelier
  module Atom
    class Source < Xml::Element
      may do
        element :generator
        element :icon
        element :id
        element :logo
        element :rights
        element :subtitle
        element :title
        element :updated
      end
      any do
        element :author
        element :category
        element :contributor
        element :link
      end
    end
  end
end
