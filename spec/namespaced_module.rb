module NamespacedModule
  include Xommelier::Xml

  xmlns 'http://example.org/'

  class EmptyRoot < Xommelier::Xml::Element
  end

  class Root < Xommelier::Xml::Element
    element :some
  end
end
