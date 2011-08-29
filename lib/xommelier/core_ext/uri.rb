require 'xommelier/core_ext/string'
require 'uri'

class URI::Generic
  def to_xommelier
    to_s
  end
end

class Uri < String
  def self.from_xommelier(value)
    if value.is_a?(URI::Generic)
      value
    else
      URI.parse(value)
    end
  end
end
