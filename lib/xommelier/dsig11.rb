require 'xommelier'
require 'xommelier/ds'

module Xommelier
  module DSIG11
    include Xommelier::Xml

    xmlns 'http://www.w3.org/2009/xmldsig11#', as: :dsig11
    schema

    class ECPointType < DS::CryptoBinary
      def self.from_xommelier(value)
        return unless value
        case value
        when DS::CryptoBinary
          new(value.raw)
        else
          new(DS::CryptoBinary.from_xommelier(value))
        end
      end
    end

    class Element < Xommelier::DS::Element
      xmlns DSIG11.xmlns
    end

    class NamedCurve < Element
      attribute :uri, as: 'URI', required: true
    end

    class Curve < Element
      element :a, as: 'A', type: DS::CryptoBinary
      element :b, as: 'B', type: DS::CryptoBinary
    end

    class Prime < Element
      element :p, as: 'P', type: DS::CryptoBinary
    end

    class GnB < Element
      element :m, as: 'M', type: Integer # positiveInteger
    end

    class TnB < GnB
      element :k, as: 'K', type: Integer # positiveInteger
    end

    class PnB < GnB
      element :k1, as: 'K1', type: Integer # positiveInteger
      element :k2, as: 'K2', type: Integer # positiveInteger
      element :k3, as: 'K3', type: Integer # positiveInteger
    end

    class FieldID < Element
      choice! do
        element ref: Prime
        element ref: TnB
        element ref: PnB
        element ref: GnB
        any! ns: :other
      end
    end

    class ValidationData < Element
      element :seed, type: DS::CryptoBinary
      attribute :hash_algorithm, type: Uri, required: true
    end

    class ECParameters < Element
      element ref: FieldID
      element ref: Curve
      element :base, as: 'Base', type: ECPointType
      element :order, as: 'Order', type: DS::CryptoBinary
      element :co_factor, as: 'CoFactor', type: Integer, count: :may
      element ref: ValidationData, count: :may
    end

    class ECKeyValue < Element
      choice! do
        element ref: ECParameters
        element ref: NamedCurve
      end
      element :public_key, as: 'PublicKey', type: ECPointType
      attribute :id, optional: true
    end

    class DEREncodedKeyValue < Element
      text
      attribute :id, optional: true
    end

    class KeyInfoReference < Element
      attribute :uri, as: 'URI', type: URI, required: true
      attribute :id, type: URI, optional: true
    end

    class X509Digest < Element
      text
      has_algorithm(

      )
    end
  end
end
