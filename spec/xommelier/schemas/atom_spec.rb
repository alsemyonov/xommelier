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

    context 'personType' do
      let(:type) { namespace.personType }

      it_behaves_like 'Complex Type' do
        context '.elements' do
          subject { elements }

          it { should include(:name) }
          it { should include(:uri, :email) }
        end
      end
    end

    context 'feedType' do
      let(:type) { namespace.feedType }

      it_behaves_like 'Complex Type' do
        context '.elements' do
          subject { elements }

          it { should include(:title, :id, :updated) }
          it { should include(:author, :category, :contributor, :generator, :icon, :link, :logo, :rights, :subtitle) }
        end
      end
    end

    context 'entryType' do
      let(:type) { namespace.entryType }

      it_behaves_like 'Complex Type' do
        context '.elements' do
          subject { elements }

          it { should include(:title, :id, :updated) }
          it { should include(:author, :category, :contributor, :link, :rights, :source) }
        end
      end
    end

    context 'sourceType' do
      let(:type) { namespace.sourceType }

      it_behaves_like 'Complex Type' do
        context '.elements' do
          subject { elements }

          it { should include(:title, :id, :updated) }
          it { should include(:author, :category, :contributor, :link, :rights) }
          it { should_not include(:source) }
        end
      end
    end
  end
end
