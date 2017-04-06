# frozen_string_literal: true

# @title Reading an Atom feed

require 'xommelier/atom/full'

feed = Xommelier::Atom::Feed.parse(open('spec/fixtures/feed.atom.xml'))
puts feed.id, feed.title, feed.updated

feed.entries do |entry|
  puts entry.id, entry.title, entry.published, entry.updated
  puts entry.content || entry.summary
end
