require 'xommelier/xml/schema'

module Xommelier
  module Schemas
    # This schema document describes the XML namespace, in a form
    # suitable for import by other schema documents.
    # @see http://www.w3.org/XML/1998/namespace.html
    # @see http://www.w3.org/TR/REC-xml for information about this namespace.
    module Xml
      extend Xommelier::Xml::Schema::DSL

      namespace "http://www.w3.org/XML/1998/namespace", as: :xml
      uses xs: "http://www.w3.org/2001/XMLSchema"

      # lang (as an attribute name): denotes an attribute whose value
      #  is a language code for the natural language of the content of
      #  any element; its value is inherited.  This name is reserved
      #  by virtue of its definition in the XML specification.
      attribute :lang, type: ns.xs.language

      # space (as an attribute name): denotes an attribute whose
      #  value is a keyword indicating what whitespace processing
      #  discipline is intended for the content of the element; its
      #  value is inherited.  This name is reserved by virtue of its
      #  definition in the XML specification.
      attribute :space, simple_type: {base: ns.xs.NCName, enumeration: ["default", "preserve"]}, default: "preserve"

      # base (as an attribute name): denotes an attribute whose value
      #  provides a URI to be used as the base for interpreting any
      #  relative URIs in the scope of the element on which it
      #  appears; its value is inherited.  This name is reserved
      #  by virtue of its definition in the XML Base specification.
      # @see http://www.w3.org/TR/xmlbase/
      attribute :base, type: ns.xs.anyURI

      attribute_group :specialAttrs do
        attribute ref: ns.xml.base
        attribute ref: ns.xml.lang
        attribute ref: ns.xml.space
      end
    end
  end
end
