# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Atom::Entry do
  describe 'instance' do
    subject { described_class.new }

    [:id, :title, :updated].each do |must_field|
      it { is_expected.to respond_to(must_field) }
    end
    [:content, :published, :rights, :source, :summary].each do |may_field|
      it { is_expected.to respond_to(may_field) }
    end
    %w(author category contributor link).each do |any_field|
      it { is_expected.to respond_to(any_field) }
      it('have plural methods for embedded collections') { is_expected.to respond_to(any_field.pluralize) }
    end
  end
end
