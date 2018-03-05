# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS do
  its('xmlns.uri') { should == 'http://www.w3.org/2000/09/xmldsig#' }
end
