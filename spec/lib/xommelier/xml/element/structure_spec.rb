# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Xml::Element::Structure do
  subject { NamespacedModule::RootWithSimpleSubelement }

  it { is_expected.to respond_to(:elements) }
  it { is_expected.to respond_to(:element) }
  it 'defines subelement' do
    expect(NamespacedModule::RootWithSimpleSubelement.elements).to have_key(:some)
  end

  it { is_expected.to respond_to(:attributes) }
  it { is_expected.to respond_to(:attribute) }
  it 'defines attribute' do
    expect(NamespacedModule::RootWithAttribute.attributes).to have_key(:another)
  end

  it { is_expected.to respond_to(:text) }
  it 'defines as containing text' do
    expect(NamespacedModule::RootWithText.new).to respond_to(:text)
  end

  it { is_expected.to respond_to(:xmlns) }
  it { expect(NamespacedModule::RootWithText.xmlns.uri).to eq('http://example.org/')}
  it { expect(NamespacedModule::RootWithAttribute.xmlns.uri).to eq('http://example.org/')}
  it { expect(Xommelier::Atom::Feed.xmlns.uri).to eq('http://www.w3.org/2005/Atom')}
end
