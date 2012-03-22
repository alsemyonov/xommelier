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

doc = Xommelier::Document.new
ivan = Author.new(given_name: 'Ivan', family_name: 'Ivanov', born_on: Time.local(1901, 6, 3))
book = Book.new(author: ivan, title: 'Ivanbook', published_on: Time.local(1934, 9, 4))
doc << book
doc.to_xml
