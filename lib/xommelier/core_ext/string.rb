class String
  def self.from_xommelier(value)
    return nil if value.is_a?(NilClass)
    value.to_s
  end

  def to_xommelier
    self
  end
end
