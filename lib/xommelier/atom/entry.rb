require 'xommelier/atom'

module Xommelier
  module Atom
    class Entry < Xml::Element
      root

      element :id, unique: true
      element :title
      element :updated, type: Time

      may do
        element :content
        element :published, type: Time
        element :rights
        element :source
        element :summary
      end

      any do
        element :author,      type: Person
        element :category,    type: Category
        element :contributor, type: Person
        element :link
      end
    end
  end
end
