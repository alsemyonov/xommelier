# frozen_string_literal: true

# @title Building an Atom feed using hash

require 'xommelier/atom/full'

feed = Xommelier::Atom::Feed.new(
  title: 'Xommelier nest elements',
  subtitle: 'Xommelier is able to build complex objects from very nested hash',
  author: { name: 'Alex', email: 'al@semyonov.us' },
  updated: Time.utc(2012, 4, 4, 4, 4),
  contributors: [
    { name: 'Ivan', email: 'ivan@example.com' },
    { name: 'Pyotr', email: 'pyotr@example.com' },
    { name: 'Sidor', email: 'sidor@example.com' }
  ],
  entries: [
    { title: 'First article', updated: Time.utc(2012, 1, 1, 1, 1) },
    { title: 'Second article', updated: Time.utc(2012, 2, 2, 2, 2) },
    { title: 'Third article', updated: Time.utc(2012, 3, 3, 3, 3) }
  ]
)

feed.author.is_a? Xommelier::Atom::Person #=> true
feed.contributors[1].is_a? Xommelier::Atom::Person #=> true
feed.entries[2].is_a? Xommelier::Atom::Entry #=> true

puts feed.to_xml
