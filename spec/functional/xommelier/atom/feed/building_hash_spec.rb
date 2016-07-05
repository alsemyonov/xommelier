# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

RSpec.describe Xommelier::Atom::Feed do
  describe '.new(Hash)' do
    let(:hash) do
      {
        title: 'Xommelier nest elements',
        subtitle: 'Xommelier is able to build complex objects from very nested hash',
        author: { name: 'Alexander', email: 'al@semyonov.us' },
        updated: Time.utc(2012, 4, 4, 4, 4),
        contributors: [
          { name: 'Artyom', email: 'sevenov@gmail.com' },
          { name: 'Sergey', email: 'sergey@ukstv.me' }
        ],
        entries: [
          { title: 'First article', updated: Time.utc(2012, 1, 1, 1, 1) },
          { title: 'Second article', updated: Time.utc(2012, 2, 2, 2, 2) },
          { title: 'Third article', updated: Time.utc(2012, 3, 3, 3, 3) }
        ]
      }
    end

    subject(:doc) { described_class.new(hash) }

    its('authors.size') { should == 1 }
    its('contributors.size') { should == 2 }
    its('entries.size') { should == 3 }

    it { expect(doc.author).to be_an(Xommelier::Atom::Person) }
    it { expect(doc.contributors[1]).to be_an(Xommelier::Atom::Person) }
    it { expect(doc.entries[1]).to be_an(Xommelier::Atom::Entry) }

    its(:to_hash) { should == hash }
    its(:to_xml) { should == load_xml_file('nested_atom') }
    it_behaves_like 'Valid XML Document'
  end
end
