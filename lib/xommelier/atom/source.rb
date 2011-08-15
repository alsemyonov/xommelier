require 'xommelier/atom'

module Xommelier
  module Atom
    class Source < Xml::Element
      may do
        element :generator, :icon, :id, :logo, :rights, :subtitle, :title, :updated
      end
      any do
        element :author, :category, :contributor, :link
      end
    end
  end
end
