module NamespacedModule
  include Xommelier::Xml

  xmlns 'http://example.org/'

  class EmptyRoot < Xommelier::Xml::Element
  end

  class RootWithSimpleSubelement < Xommelier::Xml::Element
    element :some
  end

  class RootWithAttribute < Xommelier::Xml::Element
    attribute :another
  end
end
