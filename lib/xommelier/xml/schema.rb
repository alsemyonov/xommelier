# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier'

module Xommelier
  module Xml
    module Schema
      def schema_location(new_location = nil)
        self.schema_location = new_location if new_location

        @_schema_location
      end

      def schema_location=(location)
        return unless location
        @_schema_location = location
        # For loading schema containing imports we need to temporarily chdir,
        #   so relative file names will be properly discovered
        Dir.chdir(File.dirname(location)) do
          @_schema = Nokogiri::XML::Schema(File.read(File.basename(location)))
        end
      end

      # @param [String, Nokogiri::XML::Node] schema
      # @return [Nokogiri::XML::Schema, nil]
      def schema(schema = nil)
        self.schema = schema if schema

        unless instance_variable_defined?(:@_schema)
          # Unless schema exists, try to autoload schema
          if _default_schema_location
            self.schema_location = _default_schema_location
          else
            @_schema = nil
          end
        end
        @_schema
      end

      def schema=(schema)
        if schema
          # If schema or schema path provided, set schema
          if schema.is_a?(Nokogiri::XML::Schema)
            @_schema = schema
          elsif schema.is_a?(Nokogiri::XML::Node)
            @_schema = Nokogiri::XML::Schema(schema)
          else
            self.schema_location = schema
          end
        end
        @_schema
      end

      protected

      def _available_schemas
        @_available_schemas ||= $LOAD_PATH.map do |path|
          Dir[File.join(path, 'xommelier/schemas', '*.xsd')]
        end.flatten.uniq
      end

      def _default_schema_location
        @_default_schema_location ||= begin
          file_name = /#{xmlns.as || name.demodulize.underscore}\.xsd\Z/
          _available_schemas.find { |path| path =~ file_name }
        end
      end
    end
  end
end
