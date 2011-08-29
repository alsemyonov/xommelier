class Symbol
  def self.from_xommelier(value)
    value.to_sym
  end

  def to_xommelier
    to_s
  end
end
