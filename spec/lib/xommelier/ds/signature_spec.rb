# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS::Signature do
  it { is_expected.to respond_to(:signed_info) }
  it { is_expected.to respond_to(:signature_value) }
  it { is_expected.to respond_to(:key_info) }

  describe '(signature-example-rsa.xml)' do
    let(:ds_rsa_xml) { load_xml_file('ds_rsa') }
    subject(:ds_rsa) { described_class.parse(ds_rsa_xml) }

    describe described_class do
      its(:signed_info) { should be_present }
      its(:signature_value) { should be_present }
      its(:key_info) { should be_present }
    end

    describe :signed_info do
      subject(:signed_info) { ds_rsa.signed_info }
    end
  end
end
