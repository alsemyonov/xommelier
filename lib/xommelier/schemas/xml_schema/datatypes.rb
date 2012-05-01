require 'xommelier/xml/schema'
require 'xommelier/schemas/xml_schema'

module Xommelier
  module Schemas
    module XmlSchema
      # Note this schema is NOT a normative schema - -
      # It contains types derived from all the builtin simple type definitions
      # with the same local name but in a distinct namespace, for use
      # by applications which do no wish to import the full XMLSchema
      # schema.  Since derivation is not symmetric, unexpected results may
      # follow from mixing references to these definitions with references
      # to the definitions in the XMLSchema namespace.  For example,
      # although dt:positiveInteger is derived from xs:integer, the converse
      # does not hold.
      #
      # @see http://www.w3.org/2001/XMLSchema-datatypes
      module Datatypes
        extend Xommelier::Xml::Schema::DSL

        schema :dt,
          xmlns: {
            dt: 'http://www.w3.org/2001/XMLSchema-datatypes',
            xs: 'http://www.w3.org/2001/XMLSchema'
          }
      end
    end
  end
end
