Xommelier::Schemas.send(:remove_const, :Atom) if Xommelier::Schemas.const_defined?(:Atom)
XmlSchema = Xommelier::Schemas::XmlSchema

ATOM_XMLNS = 'http://www.w3.org/2005/Atom'
XSD_XMLNS = XmlSchema.namespace.href

#ATOM = Xommelier::Xml::Schema.new(:atom, xmlns: {atom: "http://www.w3.org/2005/Atom", xs: "http://www.w3.org/2001/XMLSchema"}) do
ATOM_SCHEMA = Xommelier::Xml::Schema.new(
  :atom,
  xmlns: {atom: ATOM_XMLNS, xs: XSD_XMLNS}
) do
  #import("http://www.w3.org/XML/1998/namespace", schema_location: "http://www.w3.org/2001/03/xml.xsd")

  element(:feed, type: :feedType)
  element(:entry, type: :entryType)

  simple_type(:emailType, base: ns.xs.string, pattern: /\w+@(\w+\.)+\w+/)

  complex_type(:uriType) do
    simple_content base: ns.xs.anyURI do
      attribute_group ref: :commonAttributes
    end
  end

  complex_type(:generatorType) do
    simple_content(base: ns.xs.string) do
      attribute :uri, type: ns.xs.anyURI, required: false
      attribute :version, type: ns.xs.string, required: false
      attribute_group ref: :commonAttributes
    end
  end

  complex_type(:personType) do
    choice(min: 1, max: :unbounded) do
      element(:name, type: ns.xs.string, min: 0, max: 1)
      element(:uri, type: :uriType, min: 0, max: 1)
      element(:email, type: :emailType, min: 0, max: 1)
    end
  end

  attribute_group(:commonAttributes) do
    attribute :lang, type: ns.xs.string, min: 0, max: 0
    any_attribute ns: :other
  end
end

ATOM = Xommelier::Schemas::Atom
