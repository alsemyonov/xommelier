module Xommelier
  # This version of the Atom schema is based on version 1.0 of the format specifications,
  # found here http://www.atomenabled.org/developers/syndication/atom-format-spec.php.
  namespace "http://www.w3.org/2005/Atom", as: :atom, elementFormDefault: "qualified", attributeFormDefault: "unqualified" do
    import "http://www.w3.org/XML/1998/namespace", namespace: "http://www.w3.org/XML/1998/namespace", schemaLocation: "http://www.w3.org/2001/03/xml.xsd"
    # An Atom document may have two root elements, feed and entry, as defined in section 2.
    element :feed, type: ns.atom.feedType
    element :entry, type: ns.atom.entryType
    # The Atom text construct is defined in section 3.1 of the format spec.
    complex_type :textType, mixed: "true" do
      sequence do
        any ns: "http://www.w3.org/1999/xhtml", min: 0
      end
      attribute :type, base: ns.xs.token, enumeration: ["text", "html", "xhtml"]
      attributes ref: ns.atom.commonAttributes
    end
    # The Atom person construct is defined in section 3.2 of the format spec.
    complex_type :personType do
      choice min: 1, max: :unbounded do
        element :name, type: ns.xs.string, min: 1, max: 1
        element :uri, type: ns.atom.uriType, min: 0, max: 1
        element :email, type: ns.atom.emailType, min: 0, max: 1
        any ns: "##other"
      end
      attributes ref: ns.atom.commonAttributes
    end
    # Schema definition for an email address.
    simple_type :emailType, base: ns.xs.normalizedString, pattern: /\w+@(\w+\.)+\w+/
    # The Atom feed construct is defined in section 4.1.1 of the format spec.
    complex_type :feedType do
      choice min: 3, max: :unbounded do
        element :author, type: ns.atom.personType, min: 0, max: :unbounded
        element :category, type: ns.atom.categoryType, min: 0, max: :unbounded
        element :contributor, type: ns.atom.personType, min: 0, max: :unbounded
        element :generator, type: ns.atom.generatorType, min: 0, max: 1
        element :icon, type: ns.atom.iconType, min: 0, max: 1
        element :id, type: ns.atom.idType, min: 1, max: 1
        element :link, type: ns.atom.linkType, min: 0, max: :unbounded
        element :logo, type: ns.atom.logoType, min: 0, max: 1
        element :rights, type: ns.atom.textType, min: 0, max: 1
        element :subtitle, type: ns.atom.textType, min: 0, max: 1
        element :title, type: ns.atom.textType, min: 1, max: 1
        element :updated, type: ns.atom.dateTimeType, min: 1, max: 1
        element :entry, type: ns.atom.entryType, min: 0, max: :unbounded
        any ns: "##other", min: 0, max: :unbounded
      end
      attributes ref: ns.atom.commonAttributes
    end
    # The Atom entry construct is defined in section 4.1.2 of the format spec.
    complex_type :entryType do
      choice max: :unbounded do
        element :author, type: ns.atom.personType, min: 0, max: :unbounded
        element :category, type: ns.atom.categoryType, min: 0, max: :unbounded
        element :content, type: ns.atom.contentType, min: 0, max: 1
        element :contributor, type: ns.atom.personType, min: 0, max: :unbounded
        element :id, type: ns.atom.idType, min: 1, max: 1
        element :link, type: ns.atom.linkType, min: 0, max: :unbounded
        element :published, type: ns.atom.dateTimeType, min: 0, max: 1
        element :rights, type: ns.atom.textType, min: 0, max: 1
        element :source, type: ns.atom.textType, min: 0, max: 1
        element :summary, type: ns.atom.textType, min: 0, max: 1
        element :title, type: ns.atom.textType, min: 1, max: 1
        element :updated, type: ns.atom.dateTimeType, min: 1, max: 1
        any ns: "##other", min: 0, max: :unbounded
      end
      attributes ref: ns.atom.commonAttributes
    end
    # The Atom content construct is defined in section 4.1.3 of the format spec.
    complex_type :contentType, mixed: "true" do
      sequence do
        any ns: "##other", min: 0, max: :unbounded
      end
      attribute :type, type: ns.xs.string
      attribute :src, type: ns.xs.anyURI
      attributes ref: ns.atom.commonAttributes
    end
    # The Atom cagegory construct is defined in section 4.2.2 of the format spec.
    complex_type :categoryType do
      attribute :term, type: ns.xs.string, use: "required"
      attribute :scheme, type: ns.xs.anyURI, use: "optional"
      attribute :label, type: ns.xs.string, use: "optional"
      attributes ref: ns.atom.commonAttributes
    end
    # The Atom generator element is defined in section 4.2.4 of the format spec.
    complex_type :generatorType do
      simple_content base: ns.xs.string do
        attribute :uri, type: ns.xs.anyURI, use: "optional"
        attribute :version, type: ns.xs.string, use: "optional"
        attributes ref: ns.atom.commonAttributes
      end
    end
    # The Atom icon construct is defined in section 4.2.5 of the format spec.
    complex_type :iconType do
      simple_content base: ns.xs.anyURI do
        attributes ref: ns.atom.commonAttributes
      end
    end
    # The Atom id construct is defined in section 4.2.6 of the format spec.
    complex_type :idType do
      simple_content base: ns.xs.anyURI do
        attributes ref: ns.atom.commonAttributes
      end
    end
    # The Atom link construct is defined in section 3.4 of the format spec.
    complex_type :linkType, mixed: "true" do
      attribute :href, type: ns.xs.anyURI, use: "required"
      attribute :rel, type: ns.xs.string, use: "optional"
      attribute :type, type: ns.xs.string, use: "optional"
      attribute :hreflang, type: ns.xs.NMTOKEN, use: "optional"
      attribute :title, type: ns.xs.string, use: "optional"
      attribute :length, type: ns.xs.positiveInteger, use: "optional"
      attributes ref: ns.atom.commonAttributes
    end
    # The Atom logo construct is defined in section 4.2.8 of the format spec.
    complex_type :logoType do
      simple_content base: ns.xs.anyURI do
        attributes ref: ns.atom.commonAttributes
      end
    end
    # The Atom source construct is defined in section 4.2.11 of the format spec.
    complex_type :sourceType do
      choice max: :unbounded do
        element :author, type: ns.atom.personType, min: 0, max: :unbounded
        element :category, type: ns.atom.categoryType, min: 0, max: :unbounded
        element :contributor, type: ns.atom.personType, min: 0, max: :unbounded
        element :generator, type: ns.atom.generatorType, min: 0, max: 1
        element :icon, type: ns.atom.iconType, min: 0, max: 1
        element :id, type: ns.atom.idType, min: 0, max: 1
        element :link, type: ns.atom.linkType, min: 0, max: :unbounded
        element :logo, type: ns.atom.logoType, min: 0, max: 1
        element :rights, type: ns.atom.textType, min: 0, max: 1
        element :subtitle, type: ns.atom.textType, min: 0, max: 1
        element :title, type: ns.atom.textType, min: 0, max: 1
        element :updated, type: ns.atom.dateTimeType, min: 0, max: 1
        any ns: "##other", min: 0, max: :unbounded
      end
      attributes ref: ns.atom.commonAttributes
    end
    complex_type :uriType do
      simple_content base: ns.xs.anyURI do
        attributes ref: ns.atom.commonAttributes
      end
    end
    complex_type :dateTimeType do
      simple_content base: ns.xs.dateTime do
        attributes ref: ns.atom.commonAttributes
      end
    end
    attributes :commonAttributes, name: "commonAttributes" do
      any_attribute ns: "##other"
    end
  end
end
