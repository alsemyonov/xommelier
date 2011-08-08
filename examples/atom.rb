require 'xommelier/atom'
require 'open-uri'

# Reading a feed
feed = Xommelier::Atom::Feed.parse(open('http://example.com/blog.atom'))
puts feed.id, feed.title
puts feed.updated

feed.each(:entry) do |entry|
  puts feed.id, feed.title
  puts feed.content || feed.summary
  puts feed.published, feed.updated
end

# Building a feed
feed = Xommelier::Atom::Feed.new
feed.id = 'http://example.com/blog'
feed.title = 'Example.com blog'

5.times do |i|
  entry = Xommelier::Atom::Entry.new
  entry.id = "http://example.com/blog/#{i}"
  entry.title = "Example.com blog entry #{i}"
  entry.updated = (5 - i).days.ago

  feed << entry
end

puts feed.to_xml
