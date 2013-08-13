# coding: utf-8
require 'spec_helper'
require 'active_support/core_ext/numeric/time'
require 'xommelier/rss'

describe 'RSS feed' do
  describe 'parsing' do
    let(:rss_xml) { load_xml_file('feed.rss2.0') }
    subject(:feed) { Xommelier::RSS::Rss.parse(rss_xml) }

    it { should be_kind_of(Xommelier::RSS::Rss) }

    its(:title) { should == 'Liftoff News' }
    its(:last_build_date) { should == Time.utc(2003, 6, 10, 9, 41, 01) }
    its(:pub_date) { should == Time.utc(2003, 6, 10, 04) }
    its(:description) { should == 'Liftoff to Space Exploration.' }
    its(:link) { should == URI.parse('http://liftoff.msfc.nasa.gov/') }
    its(:docs) { should == 'http://blogs.law.harvard.edu/tech/rss' }
    its(:description) { should == 'Liftoff to Space Exploration.' }
    its(:generator) { should == 'Weblog Editor 2.0' }
    its(:managing_editor) { should == 'editor@example.com' }
    its(:web_master) { should == 'webmaster@example.com' }

    it { feed.should have(4).items }
    describe 'Item' do
      subject(:item) { feed.items[0] }

      its(:guid) { should be_an Xommelier::RSS::Guid }
      its('guid.text') { should == 'http://liftoff.msfc.nasa.gov/2003/06/03.html#item573' }
      its('guid.to_s') { should == 'http://liftoff.msfc.nasa.gov/2003/06/03.html#item573' }
      its(:guid) { should == 'http://liftoff.msfc.nasa.gov/2003/06/03.html#item573' }
      its(:title) { should == 'Star City' }
      its(:pub_date) { should == Time.utc(2003, 6, 3, 9, 39, 21) }
      its(:description) { should == 'How do Americans get ready to work with Russians aboard the International Space Station? They take a crash course in culture, language and protocol at Russia\'s <a href="http://howe.iki.rssi.ru/GCTC/gctc_e.htm">Star City</a>.' }
      its(:link) { should == URI.parse('http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp') }
    end
  end
end
