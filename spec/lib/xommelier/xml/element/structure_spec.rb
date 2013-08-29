# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Xml::Element::Structure do
  subject { NamespacedModule::RootWithSimpleSubelement }

  it { should respond_to(:elements) }
  it { should respond_to(:element) }
  it 'defines subelement' do
    NamespacedModule::RootWithSimpleSubelement.elements.should have_key(:some)
  end

  it { should respond_to(:attributes) }
  it { should respond_to(:attribute) }
  it 'defines attribute' do
    NamespacedModule::RootWithAttribute.attributes.should have_key(:another)
  end

  it { should respond_to(:text) }
  it 'defines as containing text' do
    NamespacedModule::RootWithText.new.should respond_to(:text)
  end

  it { should respond_to(:xmlns) }
  it { NamespacedModule::RootWithText.xmlns.uri.should == 'http://example.org/'}
  it { NamespacedModule::RootWithAttribute.xmlns.uri.should == 'http://example.org/'}
  it { Xommelier::Atom::Feed.xmlns.uri.should == 'http://www.w3.org/2005/Atom'}
end
