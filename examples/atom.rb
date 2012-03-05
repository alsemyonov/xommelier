require 'xommelier/atom'
require 'xommelier/atom/thread'
require 'active_support/core_ext'

# Reading a feed
feed = Xommelier::Atom::Feed.parse(open('spec/fixtures/feed.atom.xml'))
puts feed.id, feed.title, feed.updated

feed.entries do |entry|
  puts feed.id, feed.title, feed.published, feed.updated
  puts feed.content || feed.summary
end

# Building a feed
feed = Xommelier::Atom::Feed.new
feed.id = 'http://example.com/blog'
feed.title = 'Example.com blog'

entry = feed.entry = Xommelier::Atom::Entry.new(
  id: 'http://example.com/blog/2012/03/05',
  title: "Happy Xommelier's day!",
  updated: 5.days.ago
).tap do |entry|
  entry.link = Xommelier::Atom::Link.new(href: entry.id, rel: 'alternate', type: 'text/html')
  entry.links << Xommelier::Atom::Link.new(href: "#{entry.id}/comments.atom", rel: 'replies', type: 'application/atom+xml', count: 5)
end

# Add Comments
5.times do |i|
  feed.entries << Xommelier::Atom::Entry.new(
    id: "http://example.com/blog/2012/03/05#comment_#{i}",
    title: ('Hooray! ' * (i + 1)).strip,
    updated: (5 - i).days.ago
  ).tap do |comment|
    comment.in_reply_to = Xommelier::Atom::Thread::InReplyTo.new(ref: entry.id, href: entry.link.href)
  end
end

puts feed.to_xml
