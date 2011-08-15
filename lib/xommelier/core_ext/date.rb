require 'date'

class Date
  def self.from_xommelier(value)
    xmlschema(value)
  end

  def to_xommelier
    xmlschema
  end
end
