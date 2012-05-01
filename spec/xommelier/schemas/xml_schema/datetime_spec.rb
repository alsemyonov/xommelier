require 'spec_helper'
require 'active_support/core_ext/time/zones'

describe XmlSchema::DateTime do
  it_behaves_like 'Simple Type',
    deserializes: {
      '1999-05-31T13:20:00.123-05:00' => DateTime.new(1999, 05, 31, 13, 20, 0.123, '-5'),
      '1999-05-31T18:20:00Z' => Time.utc(1999, 05, 31, 18, 20, 00).to_datetime
    },
    serializes: {
      DateTime.new(1999, 05, 31, 13, 20, 0.123, '-5') => '1999-05-31T18:20:00Z',
      Date.new(1999, 05, 31) => '1999-05-31T00:00:00Z',
      Time.utc(1999, 05, 31, 18, 20, 00) => '1999-05-31T18:20:00Z',
      '1999-05-31T18:20:00Z' => '1999-05-31T18:20:00Z',
      '1999-05-31T13:20:00.123-05:00' => '1999-05-31T18:20:00Z',
    }
end

describe XmlSchema::Date do
  it_behaves_like 'Simple Type',
    deserializes: {
      '1999-05-31' => Date.new(1999, 05, 31),
    },
    serializes: {
      DateTime.new(1999, 05, 31, 13, 20, 0.123, '-5') => '1999-05-31',
      Date.new(1999, 05, 31) => '1999-05-31',
      Time.utc(1999, 05, 31, 18, 20, 00) => '1999-05-31',
      '1999-05-31T18:20:00Z' => '1999-05-31',
      '1999-05-31T13:20:00.123-05:00' => '1999-05-31',
    }
end

describe XmlSchema::Time do
  it_behaves_like 'Simple Type',
    deserializes: {
      '1999-05-31T13:20:00-05:00' => Time.new(1999, 05, 31, 13, 20, 0, '-05:00').utc,
      '1999-05-31T18:20:00Z' => Time.utc(1999, 05, 31, 18, 20, 00)
    },
    serializes: {
      DateTime.new(1999, 05, 31, 13, 20, 0.123, '-5') => '1999-05-31T18:20:00Z',
      Date.new(2012, 1, 1).to_date => '2012-01-01T00:00:00Z',
      Time.utc(1999, 05, 31, 18, 20, 00) => '1999-05-31T18:20:00Z',
      '1999-05-31T18:20:00Z' => '1999-05-31T18:20:00Z',
      '1999-05-31T13:20:00.123-05:00' => '1999-05-31T18:20:00Z',
    }
end
