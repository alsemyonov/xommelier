require 'spec_helper'
require 'xommelier/with_references'
require 'xommelier/core_ext/hash'

describe Xommelier::HashWithReferences do
  let(:person) do
    {
      name: :name
    }
  end

  let(:web_person) do
    {}.with_references!.tap do |hash|
      hash << person
      hash[:uri] = :uri
    end
  end

  let(:emailed_person) do
    {}.with_references!.tap do |hash|
      hash << web_person
      hash[:email] = :email
    end
  end

  describe 'instance' do
    subject { web_person }

    it_behaves_like 'Hash with references', [:name, :uri] do
      its(:inspect) { should == "{*{:name=>:name}, :uri=>:uri}" }
    end

    describe 'with nested references' do
      subject { emailed_person }

      it_behaves_like 'Hash with references', [:name, :uri, :email] do

        its(:inspect) { should == "{*{*{:name=>:name}, :uri=>:uri}, :email=>:email}" }
      end
    end
  end

  context 'auto injecting' do
    subject { {} }
    before { subject.add_reference(:web_person) }
    its('singleton_class.included_modules') { should include(Xommelier::WithReferences) }
  end
end
