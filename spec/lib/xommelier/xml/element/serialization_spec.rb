# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Xml::Element::Serialization do
  describe 'class' do
    subject { Xommelier::Atom::Feed }

    it { is_expected.to respond_to(:parse) }
  end
end
