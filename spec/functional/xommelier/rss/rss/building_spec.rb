require 'spec_helper'

describe 'RSS feed building' do
  subject(:rss) do
    Xommelier::RSS::Rss.new(
      channel: {
        title: 'Example Feed',
        link: 'http://example.com',
        pub_date: Time.utc(2003, 6, 10, 04),
        last_build_date: Time.utc(2003, 12, 13, 18, 30, 02),
        managing_editor: 'john.doe@example.com',
        items: [{
          title: 'RSS-Powered Robots Run Amok',
          guid: 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a',
          pub_date: Time.utc(2003, 12, 13, 18, 30, 02),
          description: 'Some text.',
          link: 'http://example.org/2003/12/13/atom03'
        }]
      }
    )
  end

  it { subject.class.schema.should be_present }
  it { should be_valid }
  its(:to_xml) { should == load_xml_file('simple_feed.rss') }
end
