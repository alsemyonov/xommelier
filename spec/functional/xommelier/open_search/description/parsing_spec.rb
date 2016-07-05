# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'
require 'xommelier/open_search'

describe Xommelier::OpenSearch::Description do
  describe '.parse' do
    let(:osd_xml) { load_xml_file('opensearch.full') }
    subject(:description) { described_class.parse(osd_xml) }

    its(:adult_content) { should  be_falsey }
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

    its('images.size') { should == 2 }
    describe '#images' do
      it { expect(subject.images[0]).to eq('http://example.com/websearch.png') }
      it { expect(subject.images[0].type).to eq('image/png') }
      it { expect(subject.images[0].height).to eq(64) }
      it { expect(subject.images[0].width).to eq(64) }
      it { expect(subject.images[1]).to eq('http://example.com/websearch.ico') }
      it { expect(subject.images[1].type).to eq('image/vnd.microsoft.icon') }
      it { expect(subject.images[1].height).to eq(16) }
      it { expect(subject.images[1].width).to eq(16) }
    end

    its('urls.size') { should == 3 }
    describe '#urls' do
      it { expect(subject.urls[0].type).to eq('application/atom+xml') }
      it { expect(subject.urls[0].template).to eq('http://example.com/?q={searchTerms}&pw={startPage?}&format=atom') }
      it { expect(subject.urls[1].type).to eq('application/rss+xml') }
      it { expect(subject.urls[1].template).to eq('http://example.com/?q={searchTerms}&pw={startPage?}&format=rss') }
      it { expect(subject.urls[2].type).to eq('text/html') }
      it { expect(subject.urls[2].template).to eq('http://example.com/?q={searchTerms}&pw={startPage?}') }
    end
  end
end
