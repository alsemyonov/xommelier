require 'xommelier'

module Xommelier
  module DS
    include Xommelier::Xml

    xmlns 'http://www.w3.org/2000/09/xmldsig#', as: :ds

    class Element < Xml::Element
      def self.find_element_name
        name.demodulize
      end

      # Defines containing attribute
      def self.attribute(name, options = {})
        options[:as] ||= name.to_s.camelcase
        super(name, options)
      end

      def self.any!(options = {})
        # TODO implement <any /> logic
      end

      def self.choice!(options = {})
        # TODO implement <choice /> logic
        may do
          yield
        end
      end

      def self.sequence!(options = {})
        # TODO implement <choice /> logic
        yield
      end
    end

    class SignatureValue < Element
      attribute :id, optional: true

      text
    end

    class CanonicalizationMethod < Element
      any! ns: :any, count: :any
      attribute :algorithm, type: Uri, required: true
    end

    class SignatureMethod < Element
      element :hmac_output_length, as: 'HMACOutputLength', type: Integer, count: :may
      any! ns: :other, count: :any
      attribute :algorithm, type: Uri, required: true
    end

    class Transform < Element
      choice! count: :any do
        any! ns: :other
        element :xpath, as: 'XPath'
      end
      attribute :algorithm, type: Uri, required: true
    end

    class Transforms < Element
      element ref: Transform, count: :many
    end

    class DigestMethod < Element
      any! ns: :other, count: :any
      attribute :algorithm, type: Uri, required: true
    end

    class Reference < Element
      element ref: Transforms, count: :may
      element ref: DigestMethod
      element :digest_value, as: 'DigestValue'
      attribute :id, optional: true
      attribute :uri, as: 'URI', type: Uri, optional: true
      attribute :type, type: Uri, optional: true
    end

    class SignedInfo < Element
      element ref: CanonicalizationMethod
      element ref: SignatureMethod
      element ref: Reference, count: :many
      attribute :id, optional: true
    end

    class DSAKeyValue < Element
      sequence! count: :may do
        element :p, as: 'P'
        element :q, as: 'Q'
      end
      element :g, as: 'G', count: :may
      element :y, as: 'Y'
      element :j, as: 'J', count: :may
      sequence! count: :may do
        element :seed, as: 'Seed'
        element :pgen_counter, as: 'PgenCounter'
      end
    end

    class RSAKeyValue < Element
      sequence! do
        element :modulus, as: 'Modulus'
        element :exponent, as: 'Exponent'
      end
    end

    class KeyValue < Element
      choice! do
        element ref: DSAKeyValue
        element ref: RSAKeyValue
        any! ns: :other
      end
    end

    class RetrievalMethod < Element
      element ref: Transforms, count: :any
      attribute :uri, as: 'URI', type: URI
      attribute :type, type: URI, optional: true
    end

    class X509IssuerSerial < Element
      element :issuer_name, as: 'X509IssuerName'
      element :serial_number, as: 'X509SerialNumber', type: Integer
    end

    class X509Data < Element
      sequence! count: :many do
        choice! do
          element :issuer_serial, type: X509IssuerSerial
          element :ski, as: 'X509SKI'
          element :subject_name, as: 'X509SubjectName'
          element :certificate, as: 'X509Certificate'
          element :crl, as: 'X509CRL'
          any! ns: :other
        end
      end
    end

    class PGPData < Element
      element :key_id, as: 'PGPKeyID', count: :may
      element :key_packet, as: 'PGPKeyPacket', count: :may
      any! ns: :other, count: :any
    end

    class SPKIData < Element
      element :sexp, as: 'SPKISexp'
      any! ns: :other, count: :may
    end

    class KeyInfo < Element
      choice! count: :many do
        element :key_name, as: 'KeyName'
        element ref: KeyValue
        element ref: RetrievalMethod
        element ref: X509Data
        element ref: PGPData
        element ref: SPKIData
        element :mgmt_data, as: 'MgmtData'
        any! ns: :other
      end
      attribute :id, optional: true
    end

    class Manifest < Element
      element ref: Reference, count: :many
      attribute :id, optional: true
    end

    class SignatureProperty < Element
      choice! do
        any! ns: :other
      end
      attribute :target, type: Uri, optional: true
      attribute :id, optional: true
    end

    class SignatureProperties < Element
      element ref: SignatureProperty, count: :many
      attribute :id, optional: true
    end

    class Object < Element
      any! ns: :any, count: :any
      attribute :id, optional: true
      attribute :mime_type, optional: true
      attribute :encoding, type: Uri, optional: true
    end

    class Signature < Element
      element ref: SignedInfo
      element ref: SignatureValue
      element ref: KeyInfo, count: :may
      element ref: Object, count: :any

      attribute :id, optional: true
    end
  end
end
