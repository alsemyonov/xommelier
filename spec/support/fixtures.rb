# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

def load_xml_file(file_name)
  open(File.join(SPEC_ROOT, 'spec', 'fixtures', "#{file_name}.xml")).read
end
