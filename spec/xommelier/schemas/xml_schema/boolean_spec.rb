require 'spec_helper'

describe XmlSchema::Boolean do
  it_behaves_like 'Simple Type',
    deserializes: {
      'true' => true,
      'false' => false,
    },
    serializes: {
      true => 'true',
      false => 'false'
    },
    not_raises: [true, false, 1, 0, 'true', 'false', '1', '0'],
    raises: ['Some', 12.minutes]
end
