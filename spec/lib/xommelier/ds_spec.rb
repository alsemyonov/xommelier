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
