require 'spec_helper'

describe XmlSchema::String do
  it_behaves_like 'Simple Type',
    deserializes: {
      'Some string' => 'Some string',
      '' => ''
    }
end

describe XmlSchema::NormalizedString do
  it_behaves_like 'Simple Type',
    deserializes: {
      'Some string' => 'Some string',
      '' => ''
    },
    serializes: {
      "\r\t Different\t spaces\n\n  " => '   Different  spaces    ',
    }
end

describe XmlSchema::Token do
  it_behaves_like 'Simple Type',
    deserializes: {
      'Some string' => 'Some string',
      '' => ''
    },
    serializes: {
      '  Leading spaces' => 'Leading spaces',
      'Trailing spaces  ' => 'Trailing spaces',
      'Continuous     spaces' => 'Continuous spaces',
      '  All     spaces  ' => 'All spaces',
      'No spaces' => 'No spaces',
      "\r\t Different\t spaces\n\n  " => 'Different spaces',
    }
end

describe XmlSchema::Language do
  it_behaves_like 'Simple Type',
    deserializes: {
      'en-US' => %w(en US),
      'en' => %w(en)
    },
    serializes: {
      'en-US' => 'en-US',
      %w(en US) => 'en-US',
      %w(en) => 'en',
    }
end

describe XmlSchema::QName do
  it_behaves_like 'Simple Type',
    deserializes: {
      'en:US' => %w(en US),
      'xs:QName' => %w(xs QName)
    },
    serializes: {
      'en:US' => 'en:US',
      %w(xs QName) => 'xs:QName',
    } do
    context '#namespace_name, #local_part' do
      let(:value) { 'xs:QName' }
      subject { instance }

      its(:value)          { should == %w(xs QName) }
      its(:namespace_name) { should == 'xs' }
      its(:local_part)     { should == 'QName' }
    end
  end
end

describe XmlSchema::AnyURI do
  it_behaves_like 'Simple Type',
    deserializes: {
      'http://ya.ru/' => URI.parse('http://ya.ru/'),
      '/any?some=another' => URI.parse('/any?some=another'),
      'http://ya.ru/?q=some%20text' => URI.parse('http://ya.ru/?q=some%20text'),
    },
    serializes: {
       URI.parse('/') => '/',
       URI.parse('http://ya.ru/') => 'http://ya.ru/',
       'http://ya.ru/' => 'http://ya.ru/',
       'http://ya.ru/?q=some%20text' => 'http://ya.ru/?q=some%20text',
    }
end

describe XmlSchema::NMTOKEN do
  it_behaves_like 'Simple Type',
    deserializes: {
      'US' => 'US'
    }
end

describe XmlSchema::NMTOKENS do
  it_behaves_like 'Simple Type',
    deserializes: {
      'US' => %w(US),
      'US RU' => %w(US RU)
    }
end
