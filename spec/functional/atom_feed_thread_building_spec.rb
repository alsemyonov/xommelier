require 'spec_helper'
#require 'xommelier/atom/full'

describe 'Atom feed building', :unless do
  let(:feed) do
    Xommelier::Atom::Feed.new.tap do |feed|
      feed.id = 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6'
      feed.title = 'Example Feed'
      feed.link = Xommelier::Atom::Link.new(href: 'http://example.org/')
      feed.updated = Time.utc(2003, 12, 13, 18, 30, 02)
      feed.author = Xommelier::Atom::Person.new(name: 'John Doe')
      feed.entry = Xommelier::Atom::Entry.new(
        title: 'Atom-Powered Robots Run Amok',
        id: 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a',
        updated: Time.utc(2003, 12, 13, 18, 30, 02),
        summary: 'Some text.',
      ).tap do |entry|
        entry.link = Xommelier::Atom::Link.new(href: 'http://example.org/2003/12/13/atom03')
        entry.links << Xommelier::Atom::Link.new(href: 'http://example.org/2003/12/13/atom03.atom', rel: 'replies', count: 1)
      end
      feed.entries << Xommelier::Atom::Entry.new(
        id: 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6b',
        title: 'Comment',
        updated: Time.utc(2003, 12, 13, 18, 30, 02)
      ).tap do |entry|
        entry.in_reply_to = Xommelier::Atom::Threading::InReplyTo.new(ref: 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a')
      end
    end
  end

  let(:built_xml)  { feed.to_xml }
  let(:parsed_xml) { Nokogiri::XML(built_xml) }
  let(:rng)        { Nokogiri::XML::RelaxNG(load_xml_file('atom.rng')) }
  let(:xsd)        { Nokogiri::XML::Schema(load_xml_file('atom.xsd')) }

  subject { built_xml }

  it { should == load_xml_file('multi_namespace_feed.atom').read }
  it('should conform to RelaxNG schema') { rng.valid?(parsed_xml).should == true }
end
