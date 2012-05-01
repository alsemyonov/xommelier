require 'xommelier/xml/schema'

module Xommelier
  # All defined Schemas
  module Schemas
    class << self
      def cleanup!
        constants.each do |constant|
          remove_const(constant) unless constant.to_sym == :XmlSchema
        end
      end

      def available_schemas
        @_available_schemas ||= $:.map do |path|
          Dir[File.join(path, 'xommelier/schemas', '*.xsd')]
        end.flatten.uniq
      end
    end
  end
end
