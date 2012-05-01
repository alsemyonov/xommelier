require 'spec_helper'
require 'xommelier/schemas/xml_schema/duration'

describe XmlSchema::Duration do
  DURATIONS = {
    'P1347Y' => 1347.years,
    'P1347M' => 1347.months,
    'P1Y2MT2H' => 1.year + 2.months + 2.hours,
    'P0Y1347M' => 1347.months,
    'P0Y1347M0D' => 1347.months,
    '-P1347M' => -1347.months,
    'P13W' => 13.weeks,
  }

  context '.parse_duration' do
    DURATIONS.each do |string, duration|
      it { XmlSchema::Duration.parse_duration(string).should == duration }
    end
  end

  it_behaves_like 'Simple Type',
    deserializes: DURATIONS,
    serializes: {
      'P1347Y' => 'P1347Y',
      '-P1347Y' => '-P1347Y',
      'P1347M' => 'P110Y7M22DT12H',
      'P13W' => 'P13W',
      13.weeks => 'P13W',
      1347.years => 'P1347Y',
      1347.months => 'P110Y7M22DT12H',
      22.days + 10.hours + 5.seconds => 'P22DT10H5S',
      22.days + 10.hours + 5.365.seconds => 'P22DT10H5.365S',
      -(22.days + 10.hours + 5.seconds) => '-P22DT10H5S',
      1347 => 'PT22M27S'
    },
    not_raises: [nil, 12, 'P12Y', 12.minutes, ''],
    raises: [true, false, :P12Y, 'Some', 'P-1347M']
end
