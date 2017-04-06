# frozen_string_literal: true
require 'xommelier'

class Author < Xommelier::Xml::Element
  attribute :id

  element :given_name
  element :family_name
  element :born_on, type: Date
end

class Book < Xommelier::Xml::Element
  attribute :isdn

  element :author, type: Author
  element :title
  element :published_on, type: Date
end
