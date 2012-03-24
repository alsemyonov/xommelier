require 'xommelier'

module Xommelier
  module XSD
    MAPPING = {
    }

    class AnyType
    end

    class AnySimpleType < AnyType
    end

    class String < AnySimpleType
    end

    class NormalizedString < String
    end

    class Token < NormalizedString
    end

    class Language < Token
    end

    class Name < Token
    end

    class NCName < Name
    end

    class ID < NCName
    end

    class IDREF < NCName
    end

    class ENTITY < NCName
    end

    class NMTOKEN < Token
    end

    class Decimal < AnySimpleType
    end

    class Integer < Decimal
    end

    class NonPositiveInteger < Integer
    end

    class NegativeInteger < NonPositiveInteger
    end

    class Long < Integer
    end

    class Int < Long
    end

    class Short < Int
    end

    class Byte < Short
    end

    class NonNegativeInteger < Integer
    end

    class PositiveInteger < NonNegativeInteger
    end

    class UnsignedLong < NonNegativeInteger
    end

    class UnsignedInt < UnsignedLong
    end

    class UnsignedShort < UnsignedInt
    end

    class UnsignedByte < UnsignedShort
    end
  end
end
