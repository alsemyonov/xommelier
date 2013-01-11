# coding: utf-8
require 'spec_helper'
require 'xommelier/open_search'

describe Xommelier::OpenSearch::Description do
  describe '.parse' do
    let(:osd_xml) { load_xml_file('opensearch.full') }
    let(:description) { Xommelier::OpenSearch::Description.parse(osd_xml) }

    subject { description }

    its(:adult_content) { should  be_false }
    its(:attribution) { should == "\n    Search data Copyright 2005, Example.com, Inc., All Rights Reserved\n  " }
    its(:contact) { should == 'admin@example.com' }
    its(:description) { should == 'Use Example.com to search the Web.' }
    its(:developer) { should == 'Example.com Development Team' }
    its(:input_encoding) { should == 'UTF-8' }
    its(:language) { should == 'en-us' }
    its(:long_name) { should == 'Example.com Web Search' }
    its(:output_encoding) { should == 'UTF-8' }
    its(:short_name) { should == 'Web Search' }
    its(:syndication_right) { should == 'open' }
    its(:tags) { should == 'example web' }

    it { should have(2).images }
    describe '#images' do
      it { subject.images[0].should == 'http://example.com/websearch.png' }
      it { subject.images[0].type.should == 'image/png' }
      it { subject.images[0].height.should == 64 }
      it { subject.images[0].width.should == 64 }
      it { subject.images[1].should == 'http://example.com/websearch.ico' }
      it { subject.images[1].type.should == 'image/vnd.microsoft.icon' }
      it { subject.images[1].height.should == 16 }
      it { subject.images[1].width.should == 16 }
    end

    it { should have(3).urls }
    describe '#urls' do
      it { subject.urls[0].type.should == 'application/atom+xml' }
      it { subject.urls[0].template.should == 'http://example.com/?q={searchTerms}&pw={startPage?}&format=atom' }
      it { subject.urls[1].type.should == 'application/rss+xml' }
      it { subject.urls[1].template.should == 'http://example.com/?q={searchTerms}&pw={startPage?}&format=rss' }
      it { subject.urls[2].type.should == 'text/html' }
      it { subject.urls[2].template.should == 'http://example.com/?q={searchTerms}&pw={startPage?}' }
    end
  end
end
