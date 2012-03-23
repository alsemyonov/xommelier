module Xommelier
  # Part 1 version: Id: structures.xsd,v 1.2 2004/01/15 11:34:25 ht Exp
  # Part 2 version: Id: datatypes.xsd,v 1.3 2004/01/23 18:11:13 ht Exp
  namespace "http://www.w3.org/2001/XMLSchema", as: :xs, blockDefault: "#all", elementFormDefault: "qualified", version: "1.0", lang: "EN" do
    # The schema corresponding to this document is normative,
    # with respect to the syntactic constraints it expresses in the
    # XML Schema language.  The documentation (within <documentation> elements)
    # below, is not normative, but rather highlights important aspects of
    # the W3C Recommendation of which this is a part
    # The simpleType element and all of its members are defined
    # towards the end of this schema document
    # Get access to the xml: attribute groups for xml:lang
    # as declared on 'schema' and 'documentation' below
    import "http://www.w3.org/XML/1998/namespace", namespace: "http://www.w3.org/XML/1998/namespace", schemaLocation: "http://www.w3.org/2001/xml.xsd"
    # This type is extended by almost all schema types
    # to allow attributes from other namespaces to be
    # added to user schemas.
    complex_type :openAttrs do
      complex_content base: ref('xs:anyType') do
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # This type is extended by all types which allow annotation
    # other than <schema> itself
    complex_type :annotated do
      complex_content base: ref('xs:openAttrs') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
        end
        attribute :id, type: ref('xs:ID')
      end
    end
    # This group is for the
    # elements which occur freely at the top level of schemas.
    # All of their types are based on the "annotated" type by extension.
    group :schemaTop do
      choice do
        group ref: ref('xs:redefinable')
        element ref: ref('xs:element')
        element ref: ref('xs:attribute')
        element ref: ref('xs:notation')
      end
    end
    # This group is for the
    # elements which can self-redefine (see <redefine> below).
    group :redefinable do
      choice do
        element ref: ref('xs:simpleType')
        element ref: ref('xs:complexType')
        element ref: ref('xs:group')
        element ref: ref('xs:attributeGroup')
      end
    end
    # A utility type, not for public use
    simple_type :formChoice, base: ref('xs:NMTOKEN'), enumeration: ["qualified", "unqualified"]
    # A utility type, not for public use
    simple_type :reducedDerivationControl, base: ref('xs:derivationControl'), enumeration: ["extension", "restriction"]
    # A utility type, not for public use
    simple_type :derivationSet do
      union do
        simple_type base: ref('xs:token'), enumeration: ["#all"]
        simple_type do
          list item_type: ref('xs:reducedDerivationControl')
        end
      end
    end
    # A utility type, not for public use
    simple_type :typeDerivationControl, base: ref('xs:derivationControl'), enumeration: ["extension", "restriction", "list", "union"]
    # A utility type, not for public use
    simple_type :fullDerivationSet do
      union do
        simple_type base: ref('xs:token'), enumeration: ["#all"]
        simple_type do
          list item_type: ref('xs:typeDerivationControl')
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-schema}
    element :schema, id: "schema" do
      complex_type do
        complex_content base: ref('xs:openAttrs') do
          sequence do
            choice min: 0, max: :unbounded do
              element ref: ref('xs:include')
              element ref: ref('xs:import')
              element ref: ref('xs:redefine')
              element ref: ref('xs:annotation')
            end
            sequence min: 0, max: :unbounded do
              group ref: ref('xs:schemaTop')
              element ref: ref('xs:annotation'), min: 0, max: :unbounded
            end
          end
          attribute :targetNamespace, type: ref('xs:anyURI')
          attribute :version, type: ref('xs:token')
          attribute :finalDefault, type: ref('xs:fullDerivationSet'), use: "optional", default: ""
          attribute :blockDefault, type: ref('xs:blockSet'), use: "optional", default: ""
          attribute :attributeFormDefault, type: ref('xs:formChoice'), use: "optional", default: "unqualified"
          attribute :elementFormDefault, type: ref('xs:formChoice'), use: "optional", default: "unqualified"
          attribute :id, type: ref('xs:ID')
          attribute ref: ref('xml:lang')
        end
      end
      key "element", name: "element" do
      # <xs:selector xpath="xs:element"/>
      # <xs:field xpath="@name"/>
      end
      key "attribute", name: "attribute" do
      # <xs:selector xpath="xs:attribute"/>
      # <xs:field xpath="@name"/>
      end
      key "type", name: "type" do
      # <xs:selector xpath="xs:complexType|xs:simpleType"/>
      # <xs:field xpath="@name"/>
      end
      key "group", name: "group" do
      # <xs:selector xpath="xs:group"/>
      # <xs:field xpath="@name"/>
      end
      key "attributeGroup", name: "attributeGroup" do
      # <xs:selector xpath="xs:attributeGroup"/>
      # <xs:field xpath="@name"/>
      end
      key "notation", name: "notation" do
      # <xs:selector xpath="xs:notation"/>
      # <xs:field xpath="@name"/>
      end
      key "identityConstraint", name: "identityConstraint" do
      # <xs:selector xpath=".//xs:key|.//xs:unique|.//xs:keyref"/>
      # <xs:field xpath="@name"/>
      end
    end
    # for maxOccurs
    simple_type :allNNI do
      union memberTypes: "xs:nonNegativeInteger" do
        simple_type base: ref('xs:NMTOKEN'), enumeration: ["unbounded"]
      end
    end
    # for all particles
    attributes :occurs, name: "occurs" do
      attribute :minOccurs, type: ref('xs:nonNegativeInteger'), use: "optional", default: "1"
      attribute :maxOccurs, type: ref('xs:allNNI'), use: "optional", default: "1"
    end
    # for element, group and attributeGroup,
    # which both define and reference
    attributes :defRef, name: "defRef" do
      attribute :name, type: ref('xs:NCName')
      attribute :ref, type: ref('xs:QName')
    end
    # 'complexType' uses this
    group :typeDefParticle do
      choice do
        element :group, type: ref('xs:groupRef')
        element ref: ref('xs:all')
        element ref: ref('xs:choice')
        element ref: ref('xs:sequence')
      end
    end
    group :nestedParticle do
      choice do
        element :element, type: ref('xs:localElement')
        element :group, type: ref('xs:groupRef')
        element ref: ref('xs:choice')
        element ref: ref('xs:sequence')
        element ref: ref('xs:any')
      end
    end
    group :particle do
      choice do
        element :element, type: ref('xs:localElement')
        element :group, type: ref('xs:groupRef')
        element ref: ref('xs:all')
        element ref: ref('xs:choice')
        element ref: ref('xs:sequence')
        element ref: ref('xs:any')
      end
    end
    complex_type :attribute do
      complex_content base: ref('xs:annotated') do
        sequence do
          element :simpleType, type: ref('xs:localSimpleType'), min: 0
        end
        attributes ref: ref('xs:defRef')
        attribute :type, type: ref('xs:QName')
        attribute :use, base: ref('xs:NMTOKEN'), enumeration: ["prohibited", "optional", "required"], use: "optional", default: "optional"
        attribute :default, type: ref('xs:string')
        attribute :fixed, type: ref('xs:string')
        attribute :form, type: ref('xs:formChoice')
      end
    end
    complex_type :topLevelAttribute do
      complex_content base: ref('xs:attribute') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          element :simpleType, type: ref('xs:localSimpleType'), min: 0
        end
        attribute :ref, use: "prohibited"
        attribute :form, use: "prohibited"
        attribute :use, use: "prohibited"
        attribute :name, type: ref('xs:NCName'), use: "required"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    group :attrDecls do
      sequence do
        choice min: 0, max: :unbounded do
          element :attribute, type: ref('xs:attribute')
          element :attributeGroup, type: ref('xs:attributeGroupRef')
        end
        element ref: ref('xs:anyAttribute'), min: 0
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-anyAttribute}
    element :anyAttribute, type: ref('xs:wildcard'), id: "anyAttribute"
    group :complexTypeModel do
      choice do
        element ref: ref('xs:simpleContent')
        element ref: ref('xs:complexContent')
        # This branch is short for
        # <complexContent>
        # <restriction base="xs:anyType">
        # ...
        # </restriction>
        # </complexContent>
        sequence do
          group ref: ref('xs:typeDefParticle'), min: 0
          group ref: ref('xs:attrDecls')
        end
      end
    end
    complex_type :complexType, abstract: "true" do
      complex_content base: ref('xs:annotated') do
        group ref: ref('xs:complexTypeModel')
        # Will be restricted to required or forbidden
        attribute :name, type: ref('xs:NCName')
        # Not allowed if simpleContent child is chosen.
        # May be overriden by setting on complexContent child.
        attribute :mixed, type: ref('xs:boolean'), use: "optional", default: "false"
        attribute :abstract, type: ref('xs:boolean'), use: "optional", default: "false"
        attribute :final, type: ref('xs:derivationSet')
        attribute :block, type: ref('xs:derivationSet')
      end
    end
    complex_type :topLevelComplexType do
      complex_content base: ref('xs:complexType') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:complexTypeModel')
        end
        attribute :name, type: ref('xs:NCName'), use: "required"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :localComplexType do
      complex_content base: ref('xs:complexType') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:complexTypeModel')
        end
        attribute :name, use: "prohibited"
        attribute :abstract, use: "prohibited"
        attribute :final, use: "prohibited"
        attribute :block, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :restrictionType do
      complex_content base: ref('xs:annotated') do
        sequence do
          choice min: 0 do
            group ref: ref('xs:typeDefParticle')
            group ref: ref('xs:simpleRestrictionModel')
          end
          group ref: ref('xs:attrDecls')
        end
        attribute :base, type: ref('xs:QName'), use: "required"
      end
    end
    complex_type :complexRestrictionType do
      complex_content base: ref('xs:restrictionType') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          # This choice is added simply to
          # make this a valid restriction per the REC
          choice min: 0 do
            group ref: ref('xs:typeDefParticle')
          end
          group ref: ref('xs:attrDecls')
        end
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :extensionType do
      complex_content base: ref('xs:annotated') do
        sequence do
          group ref: ref('xs:typeDefParticle'), min: 0
          group ref: ref('xs:attrDecls')
        end
        attribute :base, type: ref('xs:QName'), use: "required"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-complexContent}
    element :complexContent, id: "complexContent" do
      complex_type do
        complex_content base: ref('xs:annotated') do
          choice do
            element :restriction, type: ref('xs:complexRestrictionType')
            element :extension, type: ref('xs:extensionType')
          end
          # Overrides any setting on complexType parent.
          attribute :mixed, type: ref('xs:boolean')
        end
      end
    end
    complex_type :simpleRestrictionType do
      complex_content base: ref('xs:restrictionType') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          # This choice is added simply to
          # make this a valid restriction per the REC
          choice min: 0 do
            group ref: ref('xs:simpleRestrictionModel')
          end
          group ref: ref('xs:attrDecls')
        end
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :simpleExtensionType do
      complex_content base: ref('xs:extensionType') do
        # No typeDefParticle group reference
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:attrDecls')
        end
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-simpleContent}
    element :simpleContent, id: "simpleContent" do
      complex_type do
        complex_content base: ref('xs:annotated') do
          choice do
            element :restriction, type: ref('xs:simpleRestrictionType')
            element :extension, type: ref('xs:simpleExtensionType')
          end
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-complexType}
    element :complexType, type: ref('xs:topLevelComplexType'), id: "complexType"
    # A utility type, not for public use
    simple_type :blockSet do
      union do
        simple_type base: ref('xs:token'), enumeration: ["#all"]
        simple_type do
          list do
            simple_type base: ref('xs:derivationControl'), enumeration: ["extension", "restriction", "substitution"]
          end
        end
      end
    end
    # The element element can be used either
    # at the top level to define an element-type binding globally,
    # or within a content model to either reference a globally-defined
    # element or type or declare an element-type binding locally.
    # The ref form is not allowed at the top level.
    complex_type :element, abstract: "true" do
      complex_content base: ref('xs:annotated') do
        sequence do
          choice min: 0 do
            element :simpleType, type: ref('xs:localSimpleType')
            element :complexType, type: ref('xs:localComplexType')
          end
          group ref: ref('xs:identityConstraint'), min: 0, max: :unbounded
        end
        attributes ref: ref('xs:defRef')
        attribute :type, type: ref('xs:QName')
        attribute :substitutionGroup, type: ref('xs:QName')
        attributes ref: ref('xs:occurs')
        attribute :default, type: ref('xs:string')
        attribute :fixed, type: ref('xs:string')
        attribute :nillable, type: ref('xs:boolean'), use: "optional", default: "false"
        attribute :abstract, type: ref('xs:boolean'), use: "optional", default: "false"
        attribute :final, type: ref('xs:derivationSet')
        attribute :block, type: ref('xs:blockSet')
        attribute :form, type: ref('xs:formChoice')
      end
    end
    complex_type :topLevelElement do
      complex_content base: ref('xs:element') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          choice min: 0 do
            element :simpleType, type: ref('xs:localSimpleType')
            element :complexType, type: ref('xs:localComplexType')
          end
          group ref: ref('xs:identityConstraint'), min: 0, max: :unbounded
        end
        attribute :ref, use: "prohibited"
        attribute :form, use: "prohibited"
        attribute :minOccurs, use: "prohibited"
        attribute :maxOccurs, use: "prohibited"
        attribute :name, type: ref('xs:NCName'), use: "required"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :localElement do
      complex_content base: ref('xs:element') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          choice min: 0 do
            element :simpleType, type: ref('xs:localSimpleType')
            element :complexType, type: ref('xs:localComplexType')
          end
          group ref: ref('xs:identityConstraint'), min: 0, max: :unbounded
        end
        attribute :substitutionGroup, use: "prohibited"
        attribute :final, use: "prohibited"
        attribute :abstract, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-element}
    element :element, type: ref('xs:topLevelElement'), id: "element"
    # group type for explicit groups, named top-level groups and
    # group references
    complex_type :group, abstract: "true" do
      complex_content base: ref('xs:annotated') do
        group ref: ref('xs:particle'), min: 0, max: :unbounded
        attributes ref: ref('xs:defRef')
        attributes ref: ref('xs:occurs')
      end
    end
    complex_type :realGroup do
      complex_content base: ref('xs:group') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          choice min: 0, max: 1 do
            element ref: ref('xs:all')
            element ref: ref('xs:choice')
            element ref: ref('xs:sequence')
          end
        end
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :namedGroup do
      complex_content base: ref('xs:realGroup') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          choice min: 1, max: 1 do
            element :all do
              complex_type do
                complex_content base: ref('xs:all') do
                  group ref: ref('xs:allModel')
                  attribute :minOccurs, use: "prohibited"
                  attribute :maxOccurs, use: "prohibited"
                  any_attribute ns: "##other", processContents: "lax"
                end
              end
            end
            element :choice, type: ref('xs:simpleExplicitGroup')
            element :sequence, type: ref('xs:simpleExplicitGroup')
          end
        end
        attribute :name, type: ref('xs:NCName'), use: "required"
        attribute :ref, use: "prohibited"
        attribute :minOccurs, use: "prohibited"
        attribute :maxOccurs, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :groupRef do
      complex_content base: ref('xs:realGroup') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
        end
        attribute :ref, type: ref('xs:QName'), use: "required"
        attribute :name, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # group type for the three kinds of group
    complex_type :explicitGroup do
      complex_content base: ref('xs:group') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:nestedParticle'), min: 0, max: :unbounded
        end
        attribute :name, type: ref('xs:NCName'), use: "prohibited"
        attribute :ref, type: ref('xs:QName'), use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :simpleExplicitGroup do
      complex_content base: ref('xs:explicitGroup') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:nestedParticle'), min: 0, max: :unbounded
        end
        attribute :minOccurs, use: "prohibited"
        attribute :maxOccurs, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    group :allModel do
      sequence do
        element ref: ref('xs:annotation'), min: 0
        # This choice with min/max is here to
        # avoid a pblm with the Elt:All/Choice/Seq
        # Particle derivation constraint
        choice min: 0, max: :unbounded do
          element :element, type: ref('xs:narrowMaxMin')
        end
      end
    end
    # restricted max/min
    complex_type :narrowMaxMin do
      complex_content base: ref('xs:localElement') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          choice min: 0 do
            element :simpleType, type: ref('xs:localSimpleType')
            element :complexType, type: ref('xs:localComplexType')
          end
          group ref: ref('xs:identityConstraint'), min: 0, max: :unbounded
        end
        attribute :minOccurs, base: ref('xs:nonNegativeInteger'), enumeration: ["0", "1"], use: "optional", default: "1"
        attribute :maxOccurs, base: ref('xs:allNNI'), enumeration: ["0", "1"], use: "optional", default: "1"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # Only elements allowed inside
    complex_type :all do
      complex_content base: ref('xs:explicitGroup') do
        group ref: ref('xs:allModel')
        attribute :minOccurs, base: ref('xs:nonNegativeInteger'), enumeration: ["0", "1"], use: "optional", default: "1"
        attribute :maxOccurs, base: ref('xs:allNNI'), enumeration: ["1"], use: "optional", default: "1"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-all}
    element :all, type: ref('xs:all'), id: "all"
    # {http://www.w3.org/TR/xmlschema-1/#element-choice}
    element :choice, type: ref('xs:explicitGroup'), id: "choice"
    # {http://www.w3.org/TR/xmlschema-1/#element-sequence}
    element :sequence, type: ref('xs:explicitGroup'), id: "sequence"
    # {http://www.w3.org/TR/xmlschema-1/#element-group}
    element :group, type: ref('xs:namedGroup'), id: "group"
    complex_type :wildcard do
      complex_content base: ref('xs:annotated') do
        attribute :namespace, type: ref('xs:namespaceList'), use: "optional", default: "##any"
        attribute :processContents, base: ref('xs:NMTOKEN'), enumeration: ["skip", "lax", "strict"], use: "optional", default: "strict"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-any}
    element :any, id: "any" do
      complex_type do
        complex_content base: ref('xs:wildcard') do
          attributes ref: ref('xs:occurs')
        end
      end
    end
    # simple type for the value of the 'namespace' attr of
    # 'any' and 'anyAttribute'
    # Value is
    # ##any      - - any non-conflicting WFXML/attribute at all
    # ##other    - - any non-conflicting WFXML/attribute from
    # namespace other than targetNS
    # ##local    - - any unqualified non-conflicting WFXML/attribute
    # one or     - - any non-conflicting WFXML/attribute from
    # more URI        the listed namespaces
    # references
    # (space separated)
    # ##targetNamespace or ##local may appear in the above list, to
    # refer to the targetNamespace of the enclosing
    # schema or an absent targetNamespace respectively
    # A utility type, not for public use
    simple_type :namespaceList do
      union do
        simple_type base: ref('xs:token'), enumeration: ["##any", "##other"]
        simple_type do
          list do
            simple_type do
              union memberTypes: "xs:anyURI" do
                simple_type base: ref('xs:token'), enumeration: ["##targetNamespace", "##local"]
              end
            end
          end
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-attribute}
    element :attribute, type: ref('xs:topLevelAttribute'), id: "attribute"
    complex_type :attributeGroup, abstract: "true" do
      complex_content base: ref('xs:annotated') do
        group ref: ref('xs:attrDecls')
        attributes ref: ref('xs:defRef')
      end
    end
    complex_type :namedAttributeGroup do
      complex_content base: ref('xs:attributeGroup') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:attrDecls')
        end
        attribute :name, type: ref('xs:NCName'), use: "required"
        attribute :ref, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :attributeGroupRef do
      complex_content base: ref('xs:attributeGroup') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
        end
        attribute :ref, type: ref('xs:QName'), use: "required"
        attribute :name, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-attributeGroup}
    element :attributeGroup, type: ref('xs:namedAttributeGroup'), id: "attributeGroup"
    # {http://www.w3.org/TR/xmlschema-1/#element-include}
    element :include, id: "include" do
      complex_type do
        complex_content base: ref('xs:annotated') do
          attribute :schemaLocation, type: ref('xs:anyURI'), use: "required"
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-redefine}
    element :redefine, id: "redefine" do
      complex_type do
        complex_content base: ref('xs:openAttrs') do
          choice min: 0, max: :unbounded do
            element ref: ref('xs:annotation')
            group ref: ref('xs:redefinable')
          end
          attribute :schemaLocation, type: ref('xs:anyURI'), use: "required"
          attribute :id, type: ref('xs:ID')
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-import}
    element :import, id: "import" do
      complex_type do
        complex_content base: ref('xs:annotated') do
          attribute :namespace, type: ref('xs:anyURI')
          attribute :schemaLocation, type: ref('xs:anyURI')
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-selector}
    element :selector, id: "selector" do
      complex_type do
        complex_content base: ref('xs:annotated') do
          attribute :xpath, base: ref('xs:token'), pattern: /(\.\/\/)?(((child::)?((\i\c*:)?(\i\c*|\*)))|\.)(\/(((child::)?((\i\c*:)?(\i\c*|\*)))|\.))*(\|(\.\/\/)?(((child::)?((\i\c*:)?(\i\c*|\*)))|\.)(\/(((child::)?((\i\c*:)?(\i\c*|\*)))|\.))*)*/, use: "required"
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-field}
    element :field, id: "field" do
      complex_type do
        complex_content base: ref('xs:annotated') do
          attribute :xpath, base: ref('xs:token'), pattern: /(\.\/\/)?((((child::)?((\i\c*:)?(\i\c*|\*)))|\.)\/)*((((child::)?((\i\c*:)?(\i\c*|\*)))|\.)|((attribute::|@)((\i\c*:)?(\i\c*|\*))))(\|(\.\/\/)?((((child::)?((\i\c*:)?(\i\c*|\*)))|\.)\/)*((((child::)?((\i\c*:)?(\i\c*|\*)))|\.)|((attribute::|@)((\i\c*:)?(\i\c*|\*)))))*/, use: "required"
        end
      end
    end
    complex_type :keybase do
      complex_content base: ref('xs:annotated') do
        sequence do
          element ref: ref('xs:selector')
          element ref: ref('xs:field'), min: 1, max: :unbounded
        end
        attribute :name, type: ref('xs:NCName'), use: "required"
      end
    end
    # The three kinds of identity constraints, all with
    # type of or derived from 'keybase'.
    group :identityConstraint do
      choice do
        element ref: ref('xs:unique')
        element ref: ref('xs:key')
        element ref: ref('xs:keyref')
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-unique}
    element :unique, type: ref('xs:keybase'), id: "unique"
    # {http://www.w3.org/TR/xmlschema-1/#element-key}
    element :key, type: ref('xs:keybase'), id: "key"
    # {http://www.w3.org/TR/xmlschema-1/#element-keyref}
    element :keyref, id: "keyref" do
      complex_type do
        complex_content base: ref('xs:keybase') do
          attribute :refer, type: ref('xs:QName'), use: "required"
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-notation}
    element :notation, id: "notation" do
      complex_type do
        complex_content base: ref('xs:annotated') do
          attribute :name, type: ref('xs:NCName'), use: "required"
          attribute :public, type: ref('xs:public')
          attribute :system, type: ref('xs:anyURI')
        end
      end
    end
    # A utility type, not for public use
    simple_type :public, base: ref('xs:token')
    # {http://www.w3.org/TR/xmlschema-1/#element-appinfo}
    element :appinfo, id: "appinfo" do
      complex_type mixed: "true" do
        sequence min: 0, max: :unbounded do
          any processContents: "lax"
        end
        attribute :source, type: ref('xs:anyURI')
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-documentation}
    element :documentation, id: "documentation" do
      complex_type mixed: "true" do
        sequence min: 0, max: :unbounded do
          any processContents: "lax"
        end
        attribute :source, type: ref('xs:anyURI')
        attribute ref: ref('xml:lang')
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-1/#element-annotation}
    element :annotation, id: "annotation" do
      complex_type do
        complex_content base: ref('xs:openAttrs') do
          choice min: 0, max: :unbounded do
            element ref: ref('xs:appinfo')
            element ref: ref('xs:documentation')
          end
          attribute :id, type: ref('xs:ID')
        end
      end
    end
    # notations for use within XML Schema schemas
  # <xs:notation name="XMLSchemaStructures" public="structures" system="http://www.w3.org/2000/08/XMLSchema.xsd"/>
  # <xs:notation name="XML" public="REC-xml-19980210" system="http://www.w3.org/TR/1998/REC-xml-19980210"/>
    # Not the real urType, but as close an approximation as we can
    # get in the XML representation
    complex_type :anyType, mixed: "true" do
      sequence do
        any min: 0, max: :unbounded, processContents: "lax"
      end
      any_attribute processContents: "lax"
    end
    # First the built-in primitive datatypes.  These definitions are for
    # information only, the real built-in definitions are magic.
    # {http://www.w3.org/TR/xmlschema-2/#string}
    simple_type :string, base: ref('xs:anySimpleType'), white_space: {:value=>"preserve"}
    # {http://www.w3.org/TR/xmlschema-2/#boolean}
    simple_type :boolean, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#float}
    simple_type :float, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#double}
    simple_type :double, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#decimal}
    simple_type :decimal, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#duration}
    simple_type :duration, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#dateTime}
    simple_type :dateTime, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#time}
    simple_type :time, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#date}
    simple_type :date, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#gYearMonth}
    simple_type :gYearMonth, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#gYear}
    simple_type :gYear, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#gMonthDay}
    simple_type :gMonthDay, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#gDay}
    simple_type :gDay, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#gMonth}
    simple_type :gMonth, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#binary}
    simple_type :hexBinary, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#base64Binary}
    simple_type :base64Binary, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#anyURI}
    simple_type :anyURI, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#QName}
    simple_type :QName, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # {http://www.w3.org/TR/xmlschema-2/#NOTATION}
    simple_type :NOTATION, base: ref('xs:anySimpleType'), white_space: {:value=>"collapse", :fixed=>true}
    # Now the derived primitive types
    # {http://www.w3.org/TR/xmlschema-2/#normalizedString}
    simple_type :normalizedString, base: ref('xs:string'), white_space: {:value=>"replace"}
    # {http://www.w3.org/TR/xmlschema-2/#token}
    simple_type :token, base: ref('xs:normalizedString'), white_space: {:value=>"collapse"}
    # {http://www.w3.org/TR/xmlschema-2/#language}
    simple_type :language, base: ref('xs:token'), pattern: /[a-zA-Z]{1,8}(-[a-zA-Z0-9]{1,8})*/
    # {http://www.w3.org/TR/xmlschema-2/#IDREFS}
    simple_type :IDREFS do
      simple_type do
        list item_type: ref('xs:IDREF')
      end
      minimum value: "1", id: "IDREFS.minLength"
    end
    # {http://www.w3.org/TR/xmlschema-2/#ENTITIES}
    simple_type :ENTITIES do
      simple_type do
        list item_type: ref('xs:ENTITY')
      end
      minimum value: "1", id: "ENTITIES.minLength"
    end
    # {http://www.w3.org/TR/xmlschema-2/#NMTOKEN}
    simple_type :NMTOKEN, base: ref('xs:token'), pattern: /\c+/
    # {http://www.w3.org/TR/xmlschema-2/#NMTOKENS}
    simple_type :NMTOKENS do
      simple_type do
        list item_type: ref('xs:NMTOKEN')
      end
      minimum value: "1", id: "NMTOKENS.minLength"
    end
    # {http://www.w3.org/TR/xmlschema-2/#Name}
    simple_type :Name, base: ref('xs:token'), pattern: /\i\c*/
    # {http://www.w3.org/TR/xmlschema-2/#NCName}
    simple_type :NCName, base: ref('xs:Name'), pattern: /[\i-[:]][\c-[:]]*/
    # {http://www.w3.org/TR/xmlschema-2/#ID}
    simple_type :ID, base: ref('xs:NCName')
    # {http://www.w3.org/TR/xmlschema-2/#IDREF}
    simple_type :IDREF, base: ref('xs:NCName')
    # {http://www.w3.org/TR/xmlschema-2/#ENTITY}
    simple_type :ENTITY, base: ref('xs:NCName')
    # {http://www.w3.org/TR/xmlschema-2/#integer}
    simple_type :integer, base: ref('xs:decimal') do
    # <xs:fractionDigits value="0" fixed="true" id="integer.fractionDigits"/>
      pattern value: "[\\-+]?[0-9]+"
    end
    # {http://www.w3.org/TR/xmlschema-2/#nonPositiveInteger}
    simple_type :nonPositiveInteger, base: ref('xs:integer'), gte: 0
    # {http://www.w3.org/TR/xmlschema-2/#negativeInteger}
    simple_type :negativeInteger, base: ref('xs:nonPositiveInteger'), gte: -1
    # {http://www.w3.org/TR/xmlschema-2/#long}
    simple_type :long, base: ref('xs:integer'), lte: -9223372036854775808, gte: 9223372036854775807
    # {http://www.w3.org/TR/xmlschema-2/#int}
    simple_type :int, base: ref('xs:long'), lte: -2147483648, gte: 2147483647
    # {http://www.w3.org/TR/xmlschema-2/#short}
    simple_type :short, base: ref('xs:int'), lte: -32768, gte: 32767
    # {http://www.w3.org/TR/xmlschema-2/#byte}
    simple_type :byte, base: ref('xs:short'), lte: -128, gte: 127
    # {http://www.w3.org/TR/xmlschema-2/#nonNegativeInteger}
    simple_type :nonNegativeInteger, base: ref('xs:integer'), lte: 0
    # {http://www.w3.org/TR/xmlschema-2/#unsignedLong}
    simple_type :unsignedLong, base: ref('xs:nonNegativeInteger'), gte: 18446744073709551615
    # {http://www.w3.org/TR/xmlschema-2/#unsignedInt}
    simple_type :unsignedInt, base: ref('xs:unsignedLong'), gte: 4294967295
    # {http://www.w3.org/TR/xmlschema-2/#unsignedShort}
    simple_type :unsignedShort, base: ref('xs:unsignedInt'), gte: 65535
    # {http://www.w3.org/TR/xmlschema-2/#unsignedByte}
    simple_type :unsignedByte, base: ref('xs:unsignedShort'), gte: 255
    # {http://www.w3.org/TR/xmlschema-2/#positiveInteger}
    simple_type :positiveInteger, base: ref('xs:nonNegativeInteger'), lte: 1
    # A utility type, not for public use
    simple_type :derivationControl, base: ref('xs:NMTOKEN'), enumeration: ["substitution", "extension", "restriction", "list", "union"]
    group :simpleDerivation do
      choice do
        element ref: ref('xs:restriction')
        element ref: ref('xs:list')
        element ref: ref('xs:union')
      end
    end
    # #all or (possibly empty) subset of {restriction, union, list}
    simple_type :simpleDerivationSet do
      union do
        simple_type base: ref('xs:token'), enumeration: ["#all"]
        simple_type do
          list do
            simple_type base: ref('xs:derivationControl'), enumeration: ["list", "union", "restriction"]
          end
        end
      end
    end
    complex_type :simpleType, abstract: "true" do
      complex_content base: ref('xs:annotated') do
        group ref: ref('xs:simpleDerivation')
        attribute :final, type: ref('xs:simpleDerivationSet')
        # Can be restricted to required or forbidden
        attribute :name, type: ref('xs:NCName')
      end
    end
    complex_type :topLevelSimpleType do
      complex_content base: ref('xs:simpleType') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:simpleDerivation')
        end
        # Required at the top level
        attribute :name, type: ref('xs:NCName'), use: "required"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    complex_type :localSimpleType do
      complex_content base: ref('xs:simpleType') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
          group ref: ref('xs:simpleDerivation')
        end
        # Forbidden when nested
        attribute :name, use: "prohibited"
        attribute :final, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-2/#element-simpleType}
    element :simpleType, type: ref('xs:topLevelSimpleType'), id: "simpleType"
    # We should use a substitution group for facets, but
    # that's ruled out because it would allow users to
    # add their own, which we're not ready for yet.
    group :facets do
      choice do
        element ref: ref('xs:minExclusive')
        element ref: ref('xs:minInclusive')
        element ref: ref('xs:maxExclusive')
        element ref: ref('xs:maxInclusive')
        element ref: ref('xs:totalDigits')
        element ref: ref('xs:fractionDigits')
        element ref: ref('xs:length')
        element ref: ref('xs:minLength')
        element ref: ref('xs:maxLength')
        element ref: ref('xs:enumeration')
        element ref: ref('xs:whiteSpace')
        element ref: ref('xs:pattern')
      end
    end
    group :simpleRestrictionModel do
      sequence do
        element :simpleType, type: ref('xs:localSimpleType'), min: 0
        group ref: ref('xs:facets'), min: 0, max: :unbounded
      end
    end
    element :restriction, id: "restriction" do
      # base attribute and simpleType child are mutually
      # exclusive, but one or other is required
      complex_type do
        complex_content base: ref('xs:annotated') do
          group ref: ref('xs:simpleRestrictionModel')
          attribute :base, type: ref('xs:QName'), use: "optional"
        end
      end
    end
    element :list, id: "list" do
      # itemType attribute and simpleType child are mutually
      # exclusive, but one or other is required
      complex_type do
        complex_content base: ref('xs:annotated') do
          sequence do
            element :simpleType, type: ref('xs:localSimpleType'), min: 0
          end
          attribute :itemType, type: ref('xs:QName'), use: "optional"
        end
      end
    end
    element :union, id: "union" do
      # memberTypes attribute must be non-empty or there must be
      # at least one simpleType child
      complex_type do
        complex_content base: ref('xs:annotated') do
          sequence do
            element :simpleType, type: ref('xs:localSimpleType'), min: 0, max: :unbounded
          end
          attribute :memberTypes, use: "optional" do
            list item_type: ref('xs:QName')
          end
        end
      end
    end
    complex_type :facet do
      complex_content base: ref('xs:annotated') do
        attribute :value, use: "required"
        attribute :fixed, type: ref('xs:boolean'), use: "optional", default: "false"
      end
    end
    complex_type :noFixedFacet do
      complex_content base: ref('xs:facet') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
        end
        attribute :fixed, use: "prohibited"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-2/#element-minExclusive}
    element :minExclusive, type: ref('xs:facet'), id: "minExclusive"
    # {http://www.w3.org/TR/xmlschema-2/#element-minInclusive}
    element :minInclusive, type: ref('xs:facet'), id: "minInclusive"
    # {http://www.w3.org/TR/xmlschema-2/#element-maxExclusive}
    element :maxExclusive, type: ref('xs:facet'), id: "maxExclusive"
    # {http://www.w3.org/TR/xmlschema-2/#element-maxInclusive}
    element :maxInclusive, type: ref('xs:facet'), id: "maxInclusive"
    complex_type :numFacet do
      complex_content base: ref('xs:facet') do
        sequence do
          element ref: ref('xs:annotation'), min: 0
        end
        attribute :value, type: ref('xs:nonNegativeInteger'), use: "required"
        any_attribute ns: "##other", processContents: "lax"
      end
    end
    # {http://www.w3.org/TR/xmlschema-2/#element-totalDigits}
    element :totalDigits, id: "totalDigits" do
      complex_type do
        complex_content base: ref('xs:numFacet') do
          sequence do
            element ref: ref('xs:annotation'), min: 0
          end
          attribute :value, type: ref('xs:positiveInteger'), use: "required"
          any_attribute ns: "##other", processContents: "lax"
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-2/#element-fractionDigits}
    element :fractionDigits, type: ref('xs:numFacet'), id: "fractionDigits"
    # {http://www.w3.org/TR/xmlschema-2/#element-length}
    element :length, type: ref('xs:numFacet'), id: "length"
    # {http://www.w3.org/TR/xmlschema-2/#element-minLength}
    element :minLength, type: ref('xs:numFacet'), id: "minLength"
    # {http://www.w3.org/TR/xmlschema-2/#element-maxLength}
    element :maxLength, type: ref('xs:numFacet'), id: "maxLength"
    # {http://www.w3.org/TR/xmlschema-2/#element-enumeration}
    element :enumeration, type: ref('xs:noFixedFacet'), id: "enumeration"
    # {http://www.w3.org/TR/xmlschema-2/#element-whiteSpace}
    element :whiteSpace, id: "whiteSpace" do
      complex_type do
        complex_content base: ref('xs:facet') do
          sequence do
            element ref: ref('xs:annotation'), min: 0
          end
          attribute :value, base: ref('xs:NMTOKEN'), enumeration: ["preserve", "replace", "collapse"], use: "required"
          any_attribute ns: "##other", processContents: "lax"
        end
      end
    end
    # {http://www.w3.org/TR/xmlschema-2/#element-pattern}
    element :pattern, id: "pattern" do
      complex_type do
        complex_content base: ref('xs:noFixedFacet') do
          sequence do
            element ref: ref('xs:annotation'), min: 0
          end
          attribute :value, type: ref('xs:string'), use: "required"
          any_attribute ns: "##other", processContents: "lax"
        end
      end
    end
  end
end
