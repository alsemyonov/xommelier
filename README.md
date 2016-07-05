# Xommelier is an XML Sommelier

## Overview

Xommelier is an XML Object Mapper. You could describe some namespace (e.g. Atom) in ruby DSL and use it for parsing XML to Ruby objects or for building XML from Ruby objects.

Look into {Xommelier::Atom}, {Xommelier::Atom::Threading}, and {Xommelier::Atom::History} module for implementation of http://www.w3.org/2005/Atom namespace, Atom Threading, and Feed Paging and Archiving extensions

## Project links

* [Sources](https://github.com/alsemyonov/xommelier)
* [Documentation](http://rubydoc.info/gems/xommelier)
* [Issue Tracker](https://github.com/alsemyonov/xommelier/issues)
* [Wiki](https://github.com/alsemyonov/xommelier/wiki)
* [![Code Climate](https://codeclimate.com/github/alsemyonov/xommelier/badges/gpa.svg)](https://codeclimate.com/github/alsemyonov/xommelier)
* [![Test Coverage](https://codeclimate.com/github/alsemyonov/xommelier/badges/coverage.svg)](https://codeclimate.com/github/alsemyonov/xommelier/coverage)
* [![Build Status](https://travis-ci.org/alsemyonov/xommelier.png?branch=master)](http://travis-ci.org/alsemyonov/xommelier)
* [![Dependency Status](https://gemnasium.com/alsemyonov/xommelier.png)](https://gemnasium.com/alsemyonov/xommelier)

## Examples with Atom

```ruby
require 'xommelier/atom/full'
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
feed.complete = Xommelier::Atom::History::Complete.new

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
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:thr="http://purl.org/syndication/thread/1.0" xmlns:fh="http://purl.org/syndication/history/1.0">
  <id>http://example.com/blog</id>
  <title>Example.com blog</title>
  <fh:complete/>
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

### Building from hash

```ruby
feed = Xommelier::Atom::Feed.new(
  {
    title: 'Xommelier nest elements',
    subtitle: 'Xommelier is able to build complex objects from very nested hash',
    author: {name: 'Alexander', email: 'al@semyonov.us'},
    updated: Time.utc(2012, 04, 04, 04, 04),
    contributors: [
      {name: 'Ivan', email: 'ivan@example.com'},
      {name: 'Pyotr', email: 'pyotr@example.com'},
      {name: 'Sidor', email: 'sidor@example.com'},
    ],
    entries: [
      {title: 'First article', updated: Time.utc(2012, 01, 01, 01, 01)},
      {title: 'Second article', updated: Time.utc(2012, 02, 02, 02, 02)},
      {title: 'Third article', updated: Time.utc(2012, 03, 03, 03, 03)},
    ]
  }
)

feed.author # Xommelier::Atom::Person
feed.contributors[1] # Xommelier::Atom::Person
feed.entries[2] # Xommelier::Atom::Entry

puts feed.to_xml
```

will output

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Xommelier nest elements</title>
  <subtitle>Xommelier is able to build complex objects from very nested hash</subtitle>
  <author>
    <name>Alexander</name>
    <email>al@semyonov.us</email>
  </author>
  <updated>2012-04-04T04:04:00Z</updated>
  <contributor>
    <name>Ivan</name>
    <email>ivan@example.com</email>
  </contributor>
  <contributor>
    <name>Pyotr</name>
    <email>pyotr@example.com</email>
  </contributor>
  <contributor>
    <name>Sidor</name>
    <email>sidor@example.com</email>
  </contributor>
  <entry>
    <title>First article</title>
    <updated>2012-01-01T01:01:00Z</updated>
  </entry>
  <entry>
    <title>Second article</title>
    <updated>2012-02-02T02:02:00Z</updated>
  </entry>
  <entry>
    <title>Third article</title>
    <updated>2012-03-03T03:03:00Z</updated>
  </entry>
</feed>
```

## Built in XML namespaces:

1. {Xommelier::Atom} - http://www.w3.org/2005/Atom
2. {Xommelier::Atom::Threading} - http://purl.org/syndication/thread/1.0
3. {Xommelier::Atom::History} - http://purl.org/syndication/history/1.0
4. {Xommelier::OpenSearch} - http://a9.com/-/spec/opensearch/1.1/

## TODO

* Validating built XML against RelaxNG
* Converting XML Schema, RelaxNG, RelaxNG Compact and DTD into Xommelier Ruby DSL
* ActiveRecord-like automatic loading of XML Schema, RelaxNG, RelaxNG Compact and DTD without needing to write it down into ruby code

## Contributors

* Artyom Semyonov
* Sergey Ukustov

© Alexander Semyonov, 2011-2012. See MIT-LICENSE for details


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/alsemyonov/xommelier/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

