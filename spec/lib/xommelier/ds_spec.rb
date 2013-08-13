require 'spec_helper'

describe Xommelier::DS do
  its('xmlns.uri') { should == 'http://www.w3.org/2000/09/xmldsig#' }
end

describe Xommelier::DS::Signature do
  it { should respond_to(:signed_info) }
  it { should respond_to(:signature_value) }
  it { should respond_to(:key_info) }
end

describe Xommelier::DS::SignedInfo do
  it { should respond_to(:canonicalization_method) }
  it { should respond_to(:signature_method) }
  it { should respond_to(:reference) }
end

describe Xommelier::DS::CanonicalizationMethod do
  it { should respond_to(:algorithm) }

  describe '.new_omit_comments' do
    subject { described_class.new_omit_comments }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
  end

  describe '.new_with_comments' do
    subject { described_class.new_with_comments }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments' }
  end
end

describe Xommelier::DS::SignatureMethod do
  it { should respond_to(:hmac_output_length) }

  describe '.new_rsa_sha1' do
    subject { described_class.new_rsa_sha1 }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#rsa-sha1' }
  end

  describe '.new_dsa_sha1' do
    subject { described_class.new_dsa_sha1 }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#dsa-sha1' }
  end
end

describe Xommelier::DS::Transform do
  it { should respond_to(:xpath) }

  describe '.new_xslt' do
    subject { described_class.new_xslt }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/1999/REC-xslt-19991116' }
    its('algorithm_name') { should == :xslt }
  end

  describe '.new_xpath' do
    subject { described_class.new_xpath }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/1999/REC-xpath-19991116' }
    its('algorithm_name') { should == :xpath }
  end

  describe '.new_enveloped_signature' do
    subject { described_class.new_enveloped_signature }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#enveloped-signature' }
    its('algorithm_name') { should == :enveloped_signature }
  end
end

describe Xommelier::DS::DigestMethod do
  describe '.new_sha1' do
    subject { described_class.new_sha1 }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#sha1' }
  end
end

describe Xommelier::DS::Reference do
  it { should respond_to(:digest_method) }
  it { should respond_to(:digest_value) }
  it { should respond_to(:uri) }
end

describe Xommelier::DS::Signature, '(signature-example-rsa.xml)' do
  let(:ds_rsa_xml) { load_xml_file('ds_rsa') }
  subject(:ds_rsa) { Xommelier::DS::Signature.parse(ds_rsa_xml) }

  describe Xommelier::DS::Signature do
    its(:signed_info) { should be_present }
    its(:signature_value) { should be_present }
    its(:key_info) { should be_present }
  end

  describe Xommelier::DS::SignedInfo do
    subject(:signed_info) { ds_rsa.signed_info }
  end
end
