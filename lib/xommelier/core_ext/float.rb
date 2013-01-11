class Float
  def self.from_xommelier(value)
    return nil if value.blank?
    begin
      Float(value)
    rescue ArgumentError
      value
    end
  end

  def to_xommelier
    self
  end
end
