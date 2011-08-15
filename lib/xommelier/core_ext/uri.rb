require 'uri'

class URI::Generic
  def self.from_xommelier(value)
    URI.parse value
  end

  def to_xommelier
    to_s
  end
end
Uri = String
