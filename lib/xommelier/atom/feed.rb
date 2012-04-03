require 'xommelier/atom'

module Xommelier
  module Atom
    class Feed < Xml::Element
      include LinksExtension

      root

      element :id, unique: true
      element :title
      element :updated, type: Time

      may do
        element :generator, type: Generator
        element :icon
        element :logo
        element :rights
        element :subtitle, type: String
      end

      any do
        element :author,      type: Person
        element :category,    type: Category
        element :contributor, type: Person
        element :link,        type: Link
        element :entry,       type: Entry
      end
    end
  end
end
