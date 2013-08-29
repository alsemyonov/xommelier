# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::OpenSearch::Description do
  describe '.to_xml' do
    let(:hash) do
      {
        short_name:        'Web Search',
        description:       'Use Example.com to search the Web.',
        urls:              [{template: 'http://example.com/?q={searchTerms}&pw={startPage?}&format=atom',
                             type:     'application/atom+xml'},
                            {template: 'http://example.com/?q={searchTerms}&pw={startPage?}&format=rss',
                             type:     'application/rss+xml'},
                            {template: 'http://example.com/?q={searchTerms}&pw={startPage?}',
                             type:     'text/html'}],
        query:             {role: 'example', search_terms: 'cat'},
        tags:              'example web',
        contact:           'admin@example.com',
        long_name:         'Example.com Web Search',
        developer:         'Example.com Development Team',
        attribution:       "\n    Search data Copyright 2005, Example.com, Inc., All Rights Reserved\n  ",
        syndication_right: 'open',
        language:          'en-us',
        input_encoding:    'UTF-8',
        output_encoding:   'UTF-8',
        adult_content:     false,
        images:            [{height: 64, width: 64, type: 'image/png', text: 'http://example.com/websearch.png'},
                            {height: 16, width: 16, type: 'image/vnd.microsoft.icon', text: 'http://example.com/websearch.ico'}]
      }
    end
    subject(:description) { Xommelier::OpenSearch::Description.new(hash) }

    its(:to_hash) { should == hash }
    it_behaves_like 'Valid XML Document'
    its(:to_xml) { should == load_xml_file('opensearch.full') }
  end
end
