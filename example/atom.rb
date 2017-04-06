# frozen_string_literal: true
require 'xommelier/atom'
require 'xommelier/atom/threading'
require 'active_support/core_ext'

include Xommelier::Atom

# Reading a feed
feed = Feed.parse(open('spec/fixtures/feed.atom.xml'))
puts feed.id, feed.title, feed.updated

feed.entries do |entry|
  puts entry.id, entry.title, entry.published, entry.updated
  puts entry.content || entry.summary
end

# Building a feed
feed = Feed.new
feed.id = 'http://example.com/blog'
feed.title = 'Example.com blog'
feed.complete = History::Complete.new

entry = feed.entry = Entry.new(
  id: 'http://example.com/blog/2012/03/05',
  title: 'Happy Xommelier\'s day!',
  updated: 5.days.ago
).tap do |entry|
  entry.link = Link.new(href: entry.id, rel: 'alternate', type: 'text/html')
  entry.links << Link.new(href: "#{entry.id}/comments.atom", rel: 'replies', type: 'application/atom+xml', count: 5)
end

# Add Comments
5.times do |i|
  feed.entries << Entry.new(
    id: "http://example.com/blog/2012/03/05#comment_#{i}",
    title: ('Hooray! ' * (i + 1)).strip,
    updated: (5 - i).days.ago
  ).tap do |comment|
    comment.in_reply_to = Threading::InReplyTo.new(ref: entry.id, href: entry.link.href)
  end
end

puts feed.to_xml
