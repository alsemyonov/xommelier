# coding: utf-8
require 'spec_helper'
require 'active_support/core_ext/numeric/time'
require 'xommelier/atom/full'

describe Xommelier::Atom::Feed do
  describe '.parse' do
    let(:atom_xml) { load_xml_file('feed.atom') }
    subject(:feed) { Xommelier::Atom::Feed.parse(atom_xml) }

    it { should be_kind_of(Xommelier::Atom::Feed) }
    it { should respond_to(:complete?) }
    it { should respond_to(:archive?) }

    its(:id)        { should == 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6' }
    its(:title)     { should == 'Example Feed' }
    its(:updated)   { should == Time.utc(2003, 12, 13, 18, 30, 20) }
    its(:subtitle)  { should == 'A <em>lot</em> of effort went into making this effortless' }

    it { should have(3).links }
    its(:link) { should be_instance_of(Xommelier::Atom::Link) }
    it { feed.links[0].href.should == URI.parse('http://example.ru/') }
    it { feed.links[0].rel.should == 'alternate' }
    it { feed.links[0].type.should == 'text/html' }
    it { feed.links[1].href.should == URI.parse('http://example.ru/feed.atom') }
    it { feed.links[1].rel.should == 'self' }
    it { feed.links[1].type.should == 'application/atom+xml' }
    its(:feed_url) { should == URI.parse('http://example.ru/feed.atom') }
    its(:html_url) { should == URI.parse('http://example.ru/') }
    its(:next_feed_url) { should == URI.parse('http://example.ru/feed.atom?page=2') }

    its(:archive) { should be_true }
    its(:complete) { should be_false }
    its(:rights) { should == '© Mark Pilgrim, 2003' }
    describe 'Generator' do
      subject { feed.generator }
      context '#to_s' do
        it { should == 'Example Toolkit' }
        its(:text)  { should == 'Example Toolkit' }
      end
      its(:uri)     { should == URI.parse('http://example.com/') }
      its(:version) { should == '1.0' }
    end

    it { should have(1).authors }
    its(:author) { should be_instance_of(Xommelier::Atom::Person) }
    it { feed.author.name.should == 'John Doe' }

    it { feed.should have(2).entries }
    describe 'Entry' do
      subject(:entry) { feed.entries[0] }

      its(:id)        { should == 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a' }
      its(:title)     { should == 'Atom-Powered Robots Run Amok' }
      its(:updated)   { should == Time.utc(2003, 12, 13, 18, 30, 02) }
      its(:published) { should == Time.utc(2003, 12, 13, 8, 29, 29) + 4.hours }

      it { should have(3).links }
      its(:link) { should be_instance_of(Xommelier::Atom::Link) }
      it { entry.links[0].href.should == URI.parse('http://example.ru/2003/12/13/atom03') }
      it { entry.links[0].rel.should == 'alternate' }
      it { entry.links[0].type.should == 'text/html' }
      it { entry.links[1].href.should == URI.parse('http://example.org/audio/ph34r_my_podcast.mp3') }
      it { entry.links[1].rel.should == 'enclosure' }
      it { entry.links[1].type.should == 'audio/mpeg' }
      it { entry.links[1].length.should == 1337 }
      it { entry.links[2].href.should == URI.parse('http://example.ru/2003/12/13/atom03/comments.atom') }
      it { entry.links[2].rel.should == 'replies' }
      it { entry.links[2].type.should == 'application/atom+xml' }
      it { entry.links[2].count.should == 1 }
      it { entry.links[2].updated.should == Time.utc(2003, 12, 13, 18, 30, 20) }
      its(:html_url) { should == URI.parse('http://example.ru/2003/12/13/atom03') }
      its(:replies_feed_url) { should == URI.parse('http://example.ru/2003/12/13/atom03/comments.atom') }

      it { should have(1).authors }

      describe 'Author' do
        subject { entry.author }
        its(:name) { should == 'Mark Pilgrim'}
        its(:uri) { should == URI.parse('http://example.org/') }
        its(:email) { should == 'f8dy@example.com' }
      end

      it { should have(2).contributors }
      it { entry.contributors[0].name.should == 'Sam Ruby' }
      it { entry.contributors[1].name.should == 'Joe Gregorio' }
      its(:summary) { should == 'Some text.' }
      context 'Content' do
        subject { entry.content }
        it { should =~ /#{Regexp.escape('[Update: The Atom draft is finished.]')}/ }
        its(:text) do
          should == "\n      <div xmlns=\"http://www.w3.org/1999/xhtml\">\n        <p><i>[Update: The Atom draft is finished.]</i></p>\n      </div>\n    "
        end
        its(:type) { should == 'xhtml' }
        its(:lang) { should == 'en' }
        its(:base) { should == URI.parse('http://diveintomark.org/') }
        its(:content) { should ~ Regexp.new(Regexp.escape('<p><i>[Update: The Atom draft is fiished.]</i></p>')) }
      end
      its(:total) { should == 1 }

      describe 'Comment' do
        subject(:comment) { feed.entries[1] }

        its(:id) { should == 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6b' }
        its(:title) { should == 'First comment' }
        its(:updated) { should == Time.utc(2003, 12, 13, 18, 30, 20) }

        describe 'in-reply-to' do
          subject { comment.in_reply_to }
          its(:ref) { should == 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a' }
          its(:href) { should == URI.parse('http://example.ru/2003/12/13/atom03#comment_1') }
          its(:type) { should == 'text/html' }
        end
      end
    end
  end
end
