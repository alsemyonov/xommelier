# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'rspec'
shared_examples 'Valid XML Document' do
  it { expect(subject.class.schema).to be_present }
  specify do
    begin
      is_expected.to be_valid
    rescue RSpec::Expectations::ExpectationNotMetError => e
      puts subject.to_xml
      puts subject.schema_validation_errors
      raise e
    end
  end
end
