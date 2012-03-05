# Xommelier is an XML Sommelier

## Overview

Xommelier is an XML Object Mapper. You could describe some namespace (e.g. Atom) in ruby DSL and use it for parsing XML to Ruby objects or for building XML from Ruby objects.

Look into {Xommelier::Atom} and {Xommelier::Atom::Threading} module for implementation of http://www.w3.org/2005/Atom namespace and Atom Threading extension

Xommelier is work in progress: [![Build Status](https://secure.travis-ci.org/alsemyonov/xommelier.png?branch=master)](http://travis-ci.org/alsemyonov/xommelier)

## Examples with Atom

```ruby
require 'xommelier/atom'
require 'xommelier/atom/threading'
```

### Reading a feed

```ruby
feed = Xommelier::Atom::Feed.parse(open('spec/fixtures/feed.atom.xml'))
puts feed.id, feed.title, feed.updated

feed.entries do |entry|
  puts feed.id, feed.title, feed.published, feed.updated
  puts feed.content || feed.summary
end
```

### Building a feed

```ruby
feed = Xommelier::Atom::Feed.new
feed.id = 'http://example.com/blog'
feed.title = 'Example.com blog'

entry = feed.entry = Xommelier::Atom::Entry.new(
  id: 'http://example.com/blog/2012/03/05',
  title: "Happy Xommelier's day!",
  updated: 5.days.ago
).tap do |entry|
  entry.link = Xommelier::Atom::Link.new(
    href: entry.id,
    rel:  'alternate',
    type: 'text/html'
  )
  entry.links << Xommelier::Atom::Link.new(
    href:  "#{entry.id}/comments.atom",
    rel:   'replies',
    type:  'application/atom+xml',
    count: 5
  )
end

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
```

will output:

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:thr="http://purl.org/syndication/thread/1.0">
  <id>http://example.com/blog</id>
  <title>Example.com blog</title>
  <entry>
    <id>http://example.com/blog/2012/03/05</id>
    <title>Happy Xommelier's day!</title>
    <updated>2012-02-29T07:52:51+04:00</updated>
    <link href="http://example.com/blog/2012/03/05" rel="alternate" type="text/html"/>
    <link href="http://example.com/blog/2012/03/05/comments.atom" rel="replies" type="application/atom+xml" thr:count="5"/>
  </entry>
  <entry>
    <id>http://example.com/blog/2012/03/05#comment_0</id>
    <title>Hooray!</title>
    <updated>2012-02-29T07:52:51+04:00</updated>
    <thr:in-reply-to ref="http://example.com/blog/2012/03/05" href="http://example.com/blog/2012/03/05"/>
  </entry>
  <entry>
    <id>http://example.com/blog/2012/03/05#comment_1</id>
    <title>Hooray! Hooray!</title>
    <updated>2012-03-01T07:52:51+04:00</updated>
    <thr:in-reply-to ref="http://example.com/blog/2012/03/05" href="http://example.com/blog/2012/03/05"/>
  </entry>
  <entry>
    <id>http://example.com/blog/2012/03/05#comment_2</id>
    <title>Hooray! Hooray! Hooray!</title>
    <updated>2012-03-02T07:52:51+04:00</updated>
    <thr:in-reply-to ref="http://example.com/blog/2012/03/05" href="http://example.com/blog/2012/03/05"/>
  </entry>
</feed>
```

## TODO

* Validating built XML against RelaxNG and XML Schema
* Converting XML Schema, RelaxNG, RelaxNG Compact and DTD into Xommelier Ruby DSL
* ActiveRecord-like automatic loading of XML Schema, RelaxNG, RelaxNG Compact and DTD without needing to write it down into ruby code

© Alexander Semyonov, 2011-2012. See MIT-LICENSE for details
