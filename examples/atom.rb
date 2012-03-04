require 'xommelier/atom'
require 'active_support/core_ext'

# Reading a feed
feed = Xommelier::Atom::Feed.parse(open('spec/fixtures/feed.atom'))
puts feed.id, feed.title, feed.updated

feed.entries do |entry|
  puts feed.id, feed.title, feed.published, feed.updated
  puts feed.content || feed.summary
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

  feed.entries << entry
end

puts feed.to_xml
