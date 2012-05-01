# This file is automatically generated
# Please do not edit it

require 'xommelier/xml/schema'

module Xommelier
  # Qualified DC container XML Schema
  # Created 2008-02-11
  # Created by 
  # Tim Cole (t-cole3@uiuc.edu)
  # Tom Habing (thabing@uiuc.edu)
  # Jane Hunter (jane@dstc.edu.au)
  # Pete Johnston (p.johnston@ukoln.ac.uk),
  # Carl Lagoze (lagoze@cs.cornell.edu)
  # This schema declares a container element for a Qualified DC application. 
  # The declaration of the qualifieddc element uses the dcterms:elementOrRefinementContainer
  # complexType. 
  # Note that this schema does not define a target namespace. The expectation is that
  # the qualifieddc element is assigned to a namespace by an application schema 
  # which includes this schema.
  schema :xml, xmlns: {xs: "http://www.w3.org/2001/XMLSchema", dcterms: "http://purl.org/dc/terms/", dc: "http://purl.org/dc/elements/1.1/"}, elementFormDefault: "qualified", attributeFormDefault: "unqualified" do
    import "http://purl.org/dc/terms/", schemaLocation: "dcterms.xsd"
    element :qualifieddc, type: ns.dcterms.elementOrRefinementContainer
  end
end