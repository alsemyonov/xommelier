require 'spec_helper'

describe Xommelier::Xml::Serialization do
  describe 'class' do
    subject { Xommelier::Atom::Feed }

    it { should respond_to(:parse) }
  end

  describe 'parsing simple_feed' do
    let(:feed) { @feed = Xommelier::Atom::Feed.parse(open(File.join(SPEC_ROOT, 'spec', 'fixtures', 'simple_feed.atom'))) }

    it { feed.id.should == 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6' }
    it { feed.title.should == 'Example Feed' }
    it { feed.link.href.should == URI.parse('http://example.org/') }
    it { feed.updated.should == Time.utc(2003, 12, 13, 18, 30, 02) }
    it { feed.should have(1).authors }
    it { feed.author.name.should == 'John Doe' }
    it { feed.should have(1).entries }
    it { feed.entry.title.should == 'Atom-Powered Robots Run Amok' }
    it { feed.entry.link.href.should == URI.parse('http://example.org/2003/12/13/atom03') }
    it { feed.entry.id.should == 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a' }
    it { feed.entry.updated.should == Time.utc(2003, 12, 13, 18, 30, 02) }
    it { feed.entry.summary.should == 'Some text.' }
  end

  describe 'parsing feed' do
    let(:feed) { Xommelier::Atom::Feed.parse(open(File.join(SPEC_ROOT, 'spec', 'fixtures', 'feed.atom'))) }

    it { feed.should have(2).links }
    it { feed.subtitle.should == 'A <em>lot</em> of effort went into making this effortless' }
    it { feed.entry.should have(2).links }
    it { feed.entry.should have(1).authors }
    it { feed.entry.should have(2).contributors }
  end
end
