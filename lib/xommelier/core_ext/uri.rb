require 'uri'

class URI::Generic
  def to_xommelier
    to_s
  end
end

class Uri
  def self.from_xommelier(value)
    URI.parse(value)
  end
end
