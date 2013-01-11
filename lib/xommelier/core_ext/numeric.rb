class Numeric
  def self.from_xommelier(value)
    return nil if value.blank?
    begin
      value =~ /\./ ? Float(value) : Integer(value)
    rescue ArgumentError
      value
    end
  end

  def to_xommelier
    self
  end
end
