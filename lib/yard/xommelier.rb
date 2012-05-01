require 'yard'

module YARD
  class SimpleType < YARD::Handlers::Ruby::MixinHandler
    handles method_call(:simple_type)
    namespace_only

    Mixin = P('Xommelier::Xml::Schema::SimpleType')
    Extension = P('Xommelier::Xml::Schema::SimpleType::ClassMethods')

    process do
      namespace.instance_mixins.unshift(Mixin) unless namespace.instance_mixins.include?(Mixin)
      namespace.class_mixins << Extension
    end
  end

  class ComplexType < YARD::Handlers::Ruby::MixinHandler
    handles method_call(:complex_type)
    namespace_only

    Mixin = P('Xommelier::Xml::Schema::ComplexType')
    Extension = P('Xommelier::Xml::Schema::ComplexType::ClassMethods')
    SerializationMixin = P('Xommelier::Xml::Schema::ComplexType::Serialization')
    SerializationExtension = P('Xommelier::Xml::Schema::ComplexType::Serialization::ClassMethods')

    process do
      namespace.instance_mixins.unshift(Mixin) unless namespace.instance_mixins.include?(Mixin)
      namespace.class_mixins << Extension
      namespace.instance_mixins.unshift(SerializationMixin) unless namespace.instance_mixins.include?(Mixin)
      namespace.class_mixins << SerializationExtension
    end
  end
end
