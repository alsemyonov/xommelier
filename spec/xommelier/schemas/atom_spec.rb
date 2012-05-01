require 'spec_helper'

describe Xommelier::Schemas::Atom do
  it_behaves_like 'XML Schema' do
    it_has_global(
      elements: [:feed, :entry],
      types:    [:textType, :personType, :emailType, :feedType, :entryType,
                 :contentType, :categoryType, :generatorType, :iconType, :idType,
                 :linkType, :logoType, :sourceType, :uriType, :dateTimeType],
      #attribute_groups: [:commonAttributes]
    )

    context 'feed' do
      subject { elements[:feed] }

      its(:type) { should == namespace.feedType }
    end

    context 'entry' do
      subject { elements[:entry] }

      its(:type) { should == namespace.entryType }
    end

    context 'feedType' do
      let(:type) { namespace.feedType }

      it_behaves_like 'Complex Type' do
        context '.elements' do
          subject { elements }

          it { should include(:title, :id, :updated) }
          it { should include(:author, :category, :contributor, :generator, :icon, :id, :link, :logo, :rights, :subtitle) }
        end
      end
    end
  end
end
