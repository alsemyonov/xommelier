require 'spec_helper'
require 'xommelier/with_references'
require 'xommelier/core_ext/hash'

describe Xommelier::HashWithReferences do
  let(:person) do
    {
      name: :name,
      email: :email
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

    its(:count) { should == 3 }
    its(:keys) { should == [:name, :email, :uri] }
    its(:values) { should == [:name, :email, :uri] }

    its(:inspect) { should == "{*{:name=>:name, :email=>:email}, :uri=>:uri}" }

    describe 'with nested references' do
      subject { emailed_person }

      its(:count) { should == 4 }
      its(:keys) { should == [:name, :email, :uri, :email] }
      its(:values) { should == [:name, :email, :uri, :email] }
      its(:inspect) { should == "{*{*{:name=>:name, :email=>:email}, :uri=>:uri}, :email=>:email}" }
    end
  end
end
