# coding: utf-8
require 'xommelier/schemas/xml_schema'

module Xommelier
  module Schemas
    module XmlSchema
      # The {String} datatype represents character strings in XML.
      #
      # The ·value space· of string is the set of finite-length sequences of characters (as defined in [XML 1.0 (Second Edition)]) that ·match· the Char production from [XML 1.0 (Second Edition)]. A character is an atomic unit of communication; it is not further specified except to note that every character has a corresponding Universal Character Set code point, which is an integer.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#string xs:string
      class String < AnySimpleType
        type_name :string

        facets :length, :min_length, :max_length, :pattern, :enumeration, :white_space
        properties(
          ordered: false,
          bounded: false,
          cardinality: %w(contably infinite),
          numeric: false
        )
        restriction { white_space :preserve }
      end

      # {NormalizedString} represents white space normalized strings.
      #
      # Both the ·value space· and the ·lexical space· of normalizedString is the set of strings that do not contain the carriage return (#xD), line feed (#xA) nor tab (#x9) characters.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#normalizedString xs:normalizedString
      class NormalizedString < String
        type_name :normalizedString

        restriction { white_space :replace }
      end

      # {Token} represents tokenized strings.
      #
      # Both the ·value space· and the ·lexical space· of token is the set of strings that do not contain the carriage return (#xD), line feed (#xA) nor tab (#x9) characters, that have no leading or trailing spaces (#x20) and that have no internal sequences of two or more spaces.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#token xs:token
      class Token < NormalizedString
        type_name :token

        restriction { white_space :collapse }
      end

      # {Language} represents natural language identifiers as defined by by [RFC 3066].
      #
      # The ·value space· of language is the set of all strings that are valid language identifiers as defined [RFC 3066].
      #
      # The ·lexical space· of language is the set of all strings that conform to the pattern
      #   [a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#language xs:language
      # @see http://tools.ietf.org/html/rfc3066 RFC 3066, Tags for the Identification of Languages
      class Language < Token
        type_name :language

        restriction do
          # {http://www.ietf.org/rfc/rfc3066.txt}
          # pattern specifies the content of section 2.12 of XML 1.0e2
          # and RFC 3066 (Revised version of RFC 1766).
          pattern /[a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*/
        end

        def self.deserialize(value)
          case value
          when Array
            value
          when ::String, ::Symbol
            value.to_s.split(/-/)
          else
            super
          end
        end

        def primary
          value.first
        end

        def subtags
          value[1..-1]
        end

        def serialize
          value.compact.join('-')
        end
      end

      # @see http://www.w3.org/TR/xmlschema-2/#Name xs:Name
      class Name < Token
        restriction do
          # {http://www.w3.org/TR/REC-xml#NT-Name}
          # pattern matches production 5 from the XML spec
          pattern /\i\c*/
        end
      end

      # {QName} represents XML qualified names.
      #
      # The ·value space· of QName is the set of tuples !{namespace name, local part}, where namespace name is an {AnyURI} and local part is an {NCName}.
      #
      # The ·lexical space· of QName is the set of strings that ·match· the QName production of [Namespaces in XML].
      #
      # @see http://www.w3.org/TR/xmlschema-2/#QName xs:QName
      class QName < Token
        facets :length, :min_length, :max_length, :pattern, :enumeration, :white_space
        properties(
          ordered: false,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction do
          white_space :collapse, fixed: true
        end

        def self.deserialize(value)
          case value
          when Array
            namespace_name, local_part = value[0..1]
          when ::String
            namespace_name, local_part = value.split(/:/, 2)
          else
            super
          end
          namespace_name = NCName.new(namespace_name)
          local_part = NCName.new(local_part)
          [namespace_name, local_part]
        end

        def namespace_name
          value.first
        end

        def local_part
          value.last
        end

        def serialize
          value.map { |part| part.serialize }.join(':')
        end
      end

      # NCName represents XML "non-colonized" {Name}s.
      #
      # Both the ·value space· and the ·lexical space· of NCName is the set of all strings which ·match· the NCName production of [Namespaces in XML].
      #
      # @see http://www.w3.org/TR/xmlschema-2/#NCName xs:NCName
      class NCName < Name
        restriction do
          # pattern matches production 4 from the Namespaces in XML spec
          # @see http://www.w3.org/TR/REC-xml-names/#NT-NCName
          pattern /[\i-[:]][\c-[:]]*/
        end
      end

      # {ID} represents the ID attribute type from [XML 1.0 (Second Edition)]. The ·value space· of ID is the set of all strings that ·match· the {NCName} production in [Namespaces in XML]. The ·lexical space· of ID is the set of all strings that ·match· the NCName production in [Namespaces in XML]
      #
      # {http://www.w3.org/TR/xmlschema-2/#ID}
      class ID < NCName; end

      # {AnyURI} represents a Uniform Resource Identifier Reference (URI). An anyURI value can be absolute or relative, and may have an optional fragment identifier (i.e., it may be a URI Reference). This type should be used to specify the intention that the value fulfills the role of a URI as defined by [RFC 2396], as amended by [RFC 2732].
      #
      # @see http://www.w3.org/TR/xmlschema-2/#anyURI
      class AnyURI < AnySimpleType
        type_name :anyURI

        facets :length, :min_length, :max_length, :pattern, :enumeration, :white_space
        properties(
          ordered: false,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          return if value.blank?
          case value
          when URI::Generic
            value
          when ::String
            URI.parse(value)
          else
            super
          end
        end

        def serialize
          value.to_s
        end
      end

      # {IDREF} represents the IDREF attribute type from [XML 1.0 (Second Edition)].
      #
      # The ·value space· of IDREF is the set of all strings that ·match· the {NCName} production in [Namespaces in XML].
      #
      # The ·lexical space· of IDREF is the set of strings that ·match· the {NCName} production in [Namespaces in XML]
      #
      # {http://www.w3.org/TR/xmlschema-2/#IDREF}
      class IDREF < NCName; end

      # {IDREFS} represents the IDREFS attribute type from [XML 1.0 (Second Edition)].
      #
      # The ·value space· of IDREFS is the set of finite, non-zero-length sequences of IDREFs.
      #
      # The ·lexical space· of IDREFS is the set of space-separated lists of tokens, of which each token is in the ·lexical space· of {IDREF}.
      #
      # {http://www.w3.org/TR/xmlschema-2/#IDREFS}
      class IDREFS < Xml::Schema::Type
        simple_type do
          facets :length, :min_length, :max_length, :enumeration, :white_space, :pattern
          properties(
            ordered: false,
            bounded: false,
            cardinality: %w(countably infinite),
            numeric: false
          )
          list IDREF
          restriction do
            min_length 1
          end
        end
      end

      # ENTITY represents the ENTITY attribute type from [XML 1.0 (Second Edition)]. The ·value space· of ENTITY is the set of all strings that ·match· the NCName production in [Namespaces in XML] and have been declared as an unparsed entity in a document type definition. The ·lexical space· of ENTITY is the set of all strings that ·match· the NCName production in [Namespaces in XML].
      #
      # {http://www.w3.org/TR/xmlschema-2/#ENTITY}
      class ENTITY < NCName; end

      # ENTITIES represents the ENTITIES attribute type from [XML 1.0 (Second Edition)]. The ·value space· of ENTITIES is the set of finite, non-zero-length sequences of ·ENTITY·s that have been declared as unparsed entities in a document type definition. The ·lexical space· of ENTITIES is the set of space-separated lists of tokens, of which each token is in the ·lexical space· of ENTITY. The ·itemType· of ENTITIES is ENTITY.
      #
      # {http://www.w3.org/TR/xmlschema-2/#ENTITIES}
      class ENTITIES < Xml::Schema::Type
        simple_type do
          facets :length, :min_length, :max_length, :enumeration, :white_space, :pattern
          properties(
            ordered: false,
            bounded: false,
            cardinality: %w(countably infinite),
            numeric: false
          )
          list ENTITY
          restriction do
            min_length 1
          end
        end
      end

      # {NOTATION} represents the NOTATION attribute type from [XML 1.0 (Second Edition)]. The ·value space· of NOTATION is the set of {QName}s of notations declared in the current schema. The ·lexical space· of NOTATION is the set of all names of notations declared in the current schema (in the form of {QName}s).
      #
      # Schema Component Constraint: enumeration facet value required for NOTATION
      # It is an ·error· for NOTATION to be used directly in a schema. Only datatypes that are ·derived· from NOTATION by specifying a value for ·enumeration· can be used in a schema.
      # For compatibility (see Terminology (§1.4)) NOTATION should be used only on attributes and should only be used in schemas with no target namespace.
      #
      # {http://www.w3.org/TR/xmlschema-2/#NOTATION}
      class NOTATION < AnySimpleType
        facets :length, :min_length, :max_length, :pattern, :enumeration, :white_space
        properties(
          ordered: false,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }
      end

      #  NMTOKEN represents the NMTOKEN attribute type from [XML 1.0 (Second Edition)]. The ·value space· of NMTOKEN is the set of tokens that ·match· the Nmtoken production in [XML 1.0 (Second Edition)]. The ·lexical space· of NMTOKEN is the set of strings that ·match· the Nmtoken production in [XML 1.0 (Second Edition)].
      #
      # {http://www.w3.org/TR/xmlschema-2/#NMTOKEN}
      class NMTOKEN < Token
        restriction do
          # {http://www.w3.org/TR/REC-xml#NT-Nmtoken}
          # pattern matches production 7 from the XML spec
          pattern /\c+/
        end
      end

      # {NMTOKENS} represents the NMTOKENS attribute type from [XML 1.0 (Second Edition)]. The ·value space· of NMTOKENS is the set of finite, non-zero-length sequences of {NMTOKEN}s. The ·lexical space· of NMTOKENS is the set of space-separated lists of tokens, of which each token is in the ·lexical space· of NMTOKEN. The ·itemType· of NMTOKENS is NMTOKEN.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#NMTOKENS
      class NMTOKENS < Xml::Schema::Type
        simple_type do
          facets :length, :min_length, :max_length, :enumeration, :white_space, :pattern
          properties(
            ordered: false,
            bounded: false,
            cardinality: %w(countably infinite),
            numeric: false
          )
          list NMTOKEN
          restriction do
            min_length 1
          end
        end
      end
    end
  end
end

