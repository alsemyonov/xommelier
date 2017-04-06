# frozen_string_literal: true

# @title Building an Atom feed

require 'xommelier/atom/full'
require 'active_support/core_ext/numeric/time'

feed = Xommelier::Atom::Feed.new
feed.id = 'http://example.com/blog'
feed.title = 'Example.com blog'
feed.complete = Xommelier::Atom::History::Complete.new

feed.entry =
  entry = Xommelier::Atom::Entry.new(
    id: 'http://example.com/blog/2012/03/05',
    title: "Happy Xommelier's day!",
    updated: 5.days.ago
  )

# Adding the only one link
entry.link = Xommelier::Atom::Link.new(
  href: entry.id,
  rel: 'alternate',
  type: 'text/html'
)

# Add more links later
entry.links << Xommelier::Atom::Link.new(
  href: "#{entry.id}/comments.atom",
  rel: 'replies',
  type: 'application/atom+xml',
  count: 5
)

# Add Comments
3.times do |i|
  feed.entries << Xommelier::Atom::Entry.new(
    id: "http://example.com/blog/2012/03/05#comment_#{i}",
    title: ('Hooray! ' * (i + 1)).strip,
    updated: (5 - i).days.ago
  ).tap do |comment|
    comment.in_reply_to = Xommelier::Atom::Threading::InReplyTo.new(
      ref: entry.id,
      href: entry.link.href
    )
  end
end

puts feed.to_xml
