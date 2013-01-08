require 'spec_helper'

describe 'Atom feed building' do
  subject(:feed) do
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
        summary: 'Some text.'
      ).tap do |entry|
        entry.link = Xommelier::Atom::Link.new(href: 'http://example.org/2003/12/13/atom03')
      end
    end
  end

  let(:parsed_xml) { Nokogiri::XML(feed.to_xml) }
  let(:rng)        { Nokogiri::XML::RelaxNG(load_xml_file('atom.rng')) }
  let(:xsd)        { Xommelier::Atom.schema }

  it { should be_valid }

  its(:to_xml) { should == load_xml_file('simple_feed.atom') }
  it('should conform to RelaxNG schema') { rng.valid?(parsed_xml).should == true }
  it('should conform to XML Schema') { xsd.valid?(parsed_xml).should == true }
end
