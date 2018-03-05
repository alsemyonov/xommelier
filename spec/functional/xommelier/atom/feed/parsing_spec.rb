# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'
require 'active_support/core_ext/numeric/time'
require 'xommelier/atom/full'

describe Xommelier::Atom::Feed do
  describe '.parse' do
    let(:atom_xml) { load_xml_file('feed.atom') }
    subject(:feed) { described_class.parse(atom_xml) }

    it { is_expected.to be_kind_of(described_class) }
    it { is_expected.to respond_to(:complete?) }
    it { is_expected.to respond_to(:archive?) }

    its(:id)        { should == 'urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6' }
    its(:title)     { should == 'Example Feed' }
    its(:updated)   { should == Time.utc(2003, 12, 13, 18, 30, 20) }
    its(:subtitle)  { should == 'A <em>lot</em> of effort went into making this effortless' }

    its('links.size') { should == 3 }
    its(:link) { should be_instance_of(Xommelier::Atom::Link) }
    it { expect(feed.links[0].href).to eq(URI.parse('http://example.ru/')) }
    it { expect(feed.links[0].rel).to eq('alternate') }
    it { expect(feed.links[0].type).to eq('text/html') }
    it { expect(feed.links[1].href).to eq(URI.parse('http://example.ru/feed.atom')) }
    it { expect(feed.links[1].rel).to eq('self') }
    it { expect(feed.links[1].type).to eq('application/atom+xml') }
    its(:feed_url) { should == URI.parse('http://example.ru/feed.atom') }
    its(:html_url) { should == URI.parse('http://example.ru/') }
    its(:next_feed_url) { should == URI.parse('http://example.ru/feed.atom?page=2') }

    its(:archive) { should be_truthy }
    its(:complete) { should be_falsey }
    its(:rights) { should == '© Mark Pilgrim, 2003' }
    describe 'Generator' do
      subject { feed.generator }
      describe '#to_s' do
        it { is_expected.to eq('Example Toolkit') }
        its(:text) { should == 'Example Toolkit' }
      end
      its(:uri)     { should == URI.parse('http://example.com/') }
      its(:version) { should == '1.0' }
    end

    its('authors.size') { should == 1 }
    its(:author) { should be_instance_of(Xommelier::Atom::Person) }
    it { expect(feed.author.name).to eq('John Doe') }

    it { expect(feed.entries.size).to eq(2) }
    describe 'Entry' do
      subject(:entry) { feed.entries[0] }

      its(:id)        { should == 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a' }
      its(:title)     { should == 'Atom-Powered Robots Run Amok' }
      its(:updated)   { should == Time.utc(2003, 12, 13, 18, 30, 2) }
      its(:published) { should == Time.utc(2003, 12, 13, 8, 29, 29) + 4.hours }

      its('links.size') { should == 3 }
      its(:link) { should be_instance_of(Xommelier::Atom::Link) }
      it { expect(entry.links[0].href).to eq(URI.parse('http://example.ru/2003/12/13/atom03')) }
      it { expect(entry.links[0].rel).to eq('alternate') }
      it { expect(entry.links[0].type).to eq('text/html') }
      it { expect(entry.links[1].href).to eq(URI.parse('http://example.org/audio/ph34r_my_podcast.mp3')) }
      it { expect(entry.links[1].rel).to eq('enclosure') }
      it { expect(entry.links[1].type).to eq('audio/mpeg') }
      it { expect(entry.links[1].length).to eq(1337) }
      it { expect(entry.links[2].href).to eq(URI.parse('http://example.ru/2003/12/13/atom03/comments.atom')) }
      it { expect(entry.links[2].rel).to eq('replies') }
      it { expect(entry.links[2].type).to eq('application/atom+xml') }
      it { expect(entry.links[2].count).to eq(1) }
      it { expect(entry.links[2].updated).to eq(Time.utc(2003, 12, 13, 18, 30, 20)) }
      its(:html_url) { should == URI.parse('http://example.ru/2003/12/13/atom03') }
      its(:replies_feed_url) { should == URI.parse('http://example.ru/2003/12/13/atom03/comments.atom') }

      its('authors.size') { should == 1 }

      describe 'Author' do
        subject { entry.author }
        its(:name) { should == 'Mark Pilgrim' }
        its(:uri) { should == URI.parse('http://example.org/') }
        its(:email) { should == 'f8dy@example.com' }
      end

      its('contributors.size') { should == 2 }
      it { expect(entry.contributors[0].name).to eq('Sam Ruby') }
      it { expect(entry.contributors[1].name).to eq('Joe Gregorio') }
      its(:summary) { should == 'Some text.' }
      describe 'Content' do
        subject { entry.content }
        it { is_expected.to match(/#{Regexp.escape('[Update: The Atom draft is finished.]')}/) }
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
