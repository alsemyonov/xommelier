require 'xommelier/with_references'

class Hash
  def with_references
    dup.with_references!
  end

  def with_references!
    extend Xommelier::WithReferences
    self
  end

  def add_reference(object)
    with_references!.add_reference(object)
  end
end
