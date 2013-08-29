# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Atom::Feed do
  describe '.new(Hash)' do
    let(:hash) do
      {
        title: 'Xommelier nest elements',
        subtitle: 'Xommelier is able to build complex objects from very nested hash',
        author: {name: 'Alexander', email: 'al@semyonov.us'},
        updated: Time.utc(2012, 04, 04, 04, 04),
        contributors: [
                 {name: 'Artyom', email: 'sevenov@gmail.com'},
                 {name: 'Sergey', email: 'sergey@ukstv.me'},
               ],
        entries: [
                 {title: 'First article', updated: Time.utc(2012, 01, 01, 01, 01)},
                 {title: 'Second article', updated: Time.utc(2012, 02, 02, 02, 02)},
                 {title: 'Third article', updated: Time.utc(2012, 03, 03, 03, 03)},
               ]
      }
    end

    subject(:doc) { Xommelier::Atom::Feed.new(hash) }

    it { should have(1).authors }
    it { should have(2).contributors }
    it { should have(3).entries }

    it { doc.author.should be_an(Xommelier::Atom::Person) }
    it { doc.contributors[1].should be_an(Xommelier::Atom::Person) }
    it { doc.entries[1].should be_an(Xommelier::Atom::Entry) }

    its(:to_hash) { should == hash}
    its(:to_xml) { should == load_xml_file('nested_atom') }
    it_behaves_like 'Valid XML Document'
  end
end
