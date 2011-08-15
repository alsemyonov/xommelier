class Time
  def self.from_xommelier(value)
    Time.iso8601 value
  end

  def to_xommelier
    iso8601
  end
end
