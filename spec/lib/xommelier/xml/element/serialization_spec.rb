require 'spec_helper'

describe Xommelier::Xml::Element::Serialization do
  describe 'class' do
    subject { Xommelier::Atom::Feed }

    it { should respond_to(:parse) }

  end
  describe 'parsing' do
    before do
      @feed = Xommelier::Atom::Feed.parse(open(File.join(SPEC_ROOT, 'spec', 'fixtures', 'simple_feed.atom')))
    end

    it { @feed.title.should == 'Example Feed' }
    it { @feed.link.href.to_s.should == 'http://example.org/' }
  end
end
