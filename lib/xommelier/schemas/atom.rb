require 'xommelier/xml/schema'

module Xommelier
  # This version of the Atom schema is based on version 1.0 of the format specifications,
  # found here http://www.atomenabled.org/developers/syndication/atom-format-spec.php.
  module Schemas
    module Atom
      extend Xommelier::Xml::Schema::DSL

      schema :atom,
        xmlns: {
          atom: 'http://www.w3.org/2005/Atom',
          xs: 'http://www.w3.org/2001/XMLSchema',
          xml: 'http://www.w3.org/XML/1998/namespace',
        },
        elementFormDefault: "qualified",
        attributeFormDefault: "unqualified"

      import 'http://www.w3.org/XML/1998/namespace', schemaLocation: 'http://www.w3.org/2001/03/xml.xsd'

      # An Atom document may have two root elements, feed and entry, as defined in section 2.
      element :feed, type: :feedType
      element :entry, type: :entryType

      attribute_group :commonAttributes, name: "commonAttributes" do
        any_attribute ns: "##other"
      end

      complex_type :uriType do
        simple_content base: ns.xs.anyURI do
          attribute_group ref: :commonAttributes
        end
      end

      complex_type :dateTimeType do
        simple_content base: ns.xs.dateTime do
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom text construct is defined in section 3.1 of the format spec.
      class Text < XmlSchema::AnyType
        type_name :textType

        complex_type mixed: true do
          sequence do
            any ns: "http://www.w3.org/1999/xhtml", min: 0
          end
          attribute :type, simple_type: {base: ns.xs.token, enumeration: ["text", "html", "xhtml"]}
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom person construct is defined in section 3.2 of the format spec.
      class Person < XmlSchema::AnyType
        type_name :personType

        complex_type do
          choice min: 1, max: :unbounded do
            element :name, type: ns.xs.string, min: 1, max: 1
            element :uri, type: :uriType, min: 0, max: 1
            element :email, type: :emailType, min: 0, max: 1
            any ns: "##other"
          end
          attribute_group ref: :commonAttributes
        end
      end

      # Schema definition for an email address.
      simple_type :emailType, base: ns.xs.normalizedString, pattern: /\w+@(\w+\.)+\w+/

      # The Atom feed construct is defined in section 4.1.1 of the format spec.
      class Feed < XmlSchema::AnyType
        type_name :feedType

        complex_type do
          choice min: 3, max: :unbounded do
            element :author, type: :personType, min: 0, max: :unbounded
            element :category, type: :categoryType, min: 0, max: :unbounded
            element :contributor, type: :personType, min: 0, max: :unbounded
            element :generator, type: :generatorType, min: 0, max: 1
            element :icon, type: :iconType, min: 0, max: 1
            element :id, type: :idType, min: 1, max: 1
            element :link, type: :linkType, min: 0, max: :unbounded
            element :logo, type: :logoType, min: 0, max: 1
            element :rights, type: :textType, min: 0, max: 1
            element :subtitle, type: :textType, min: 0, max: 1
            element :title, type: :textType, min: 1, max: 1
            element :updated, type: :dateTimeType, min: 1, max: 1
            element :entry, type: :entryType, min: 0, max: :unbounded
            any ns: "##other", min: 0, max: :unbounded
          end
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom entry construct is defined in section 4.1.2 of the format spec.
      class Entry < XmlSchema::AnyType
        type_name :entryType

        complex_type do
          choice max: :unbounded do
            element :author, type: :personType, min: 0, max: :unbounded
            element :category, type: :categoryType, min: 0, max: :unbounded
            element :content, type: :contentType, min: 0, max: 1
            element :contributor, type: :personType, min: 0, max: :unbounded
            element :id, type: :idType, min: 1, max: 1
            element :link, type: :linkType, min: 0, max: :unbounded
            element :published, type: :dateTimeType, min: 0, max: 1
            element :rights, type: :textType, min: 0, max: 1
            element :source, type: :textType, min: 0, max: 1
            element :summary, type: :textType, min: 0, max: 1
            element :title, type: :textType, min: 1, max: 1
            element :updated, type: :dateTimeType, min: 1, max: 1
            any ns: "##other", min: 0, max: :unbounded
          end
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom content construct is defined in section 4.1.3 of the format spec.
      complex_type :contentType, mixed: true do
        sequence do
          any ns: "##other", min: 0, max: :unbounded
        end
        attribute :type, type: ns.xs.string
        attribute :src, type: ns.xs.anyURI
        attribute_group ref: :commonAttributes
      end

      # The Atom cagegory construct is defined in section 4.2.2 of the format spec.
      complex_type :categoryType do
        attribute :term, type: ns.xs.string, required: true
        attribute :scheme, type: ns.xs.anyURI, required: false
        attribute :label, type: ns.xs.string, required: false
        attribute_group ref: :commonAttributes
      end

      # The Atom generator element is defined in section 4.2.4 of the format spec.
      complex_type :generatorType do
        simple_content base: ns.xs.string do
          attribute :uri, type: ns.xs.anyURI, required: false
          attribute :version, type: ns.xs.string, required: false
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom icon construct is defined in section 4.2.5 of the format spec.
      complex_type :iconType do
        simple_content base: ns.xs.anyURI do
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom id construct is defined in section 4.2.6 of the format spec.
      complex_type :idType do
        simple_content base: ns.xs.anyURI do
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom link construct is defined in section 3.4 of the format spec.
      complex_type :linkType, mixed: true do
        attribute :href, type: ns.xs.anyURI, required: true
        attribute :rel, type: ns.xs.string, required: false
        attribute :type, type: ns.xs.string, required: false
        attribute :hreflang, type: ns.xs.NMTOKEN, required: false
        attribute :title, type: ns.xs.string, required: false
        attribute :length, type: ns.xs.positiveInteger, required: false
        attribute_group ref: :commonAttributes
      end

      # The Atom logo construct is defined in section 4.2.8 of the format spec.
      complex_type :logoType do
        simple_content base: ns.xs.anyURI do
          attribute_group ref: :commonAttributes
        end
      end

      # The Atom source construct is defined in section 4.2.11 of the format spec.
      complex_type :sourceType do
        choice max: :unbounded do
          element :author, type: :personType, min: 0, max: :unbounded
          element :category, type: :categoryType, min: 0, max: :unbounded
          element :contributor, type: :personType, min: 0, max: :unbounded
          element :generator, type: :generatorType, min: 0, max: 1
          element :icon, type: :iconType, min: 0, max: 1
          element :id, type: :idType, min: 0, max: 1
          element :link, type: :linkType, min: 0, max: :unbounded
          element :logo, type: :logoType, min: 0, max: 1
          element :rights, type: :textType, min: 0, max: 1
          element :subtitle, type: :textType, min: 0, max: 1
          element :title, type: :textType, min: 0, max: 1
          element :updated, type: :dateTimeType, min: 0, max: 1
          any ns: "##other", min: 0, max: :unbounded
        end
        attribute_group ref: :commonAttributes
      end
    end
  end
end
