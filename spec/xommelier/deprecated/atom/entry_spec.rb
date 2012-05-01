require 'spec_helper'

describe Xommelier::Schemas::Atom::Entry, :unless do
  describe 'instance' do
    subject { described_class.new }

    [:id, :title, :updated].each do |must_field|
      it { should respond_to(must_field) }
    end
    [:content, :published, :rights, :source, :summary].each do |may_field|
      it { should respond_to(may_field) }
    end
    %w(author category contributor link).each do |any_field|
      it { should respond_to(any_field) }
      it('have plural methods for embedded collections') { should respond_to(any_field.pluralize) }
    end
  end
end
