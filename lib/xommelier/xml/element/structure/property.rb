# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

module Xommelier
  module Xml
    class Element
      module Structure
        class Property
          def initialize(name, options)
            @name = name
            @options = self.class.const_get(:DEFAULTS).merge(options)
          end

          attr_reader :name, :options

          def writer
            @writer ||= "#{name}="
          end

          # @return [Xommelier::Xml::Namespace]
          def ns
            options[:ns]
          end

          def default
            options[:default]
          end

          # @return [Class]
          def type
            options[:type]
          end

          def complex_type?
            type < Xml::Element
          end

          # @return [true, false] has default value?
          def default?
            options.key?(:default) && required?
          end

          def inspect
            "#<Xommelier::X::E::S::#{self.class.name.demodulize}:0x#{object_id.to_s(16)} #{instance_variables.map { |ivar| "#{ivar}=#{instance_variable_get(ivar).inspect}" }.join(' ')}>"
          end

          protected

          def overrides
            @overrides ||= {}
          end
        end

        class Element < Property
          DEFAULTS = {
            type: String,
            count: :one
          }.freeze

          def node_type
            :element
          end

          def element_name
            @element_name ||= options.delete(:as) { name }.to_s
          end

          def serializable_element_name
            @serializable_element_name ||= if %w(class id text).include?(element_name)
                                             element_name + '_'
                                           else
                                             element_name
                                           end
          end

          def fixed
            options[:fixed]
          end

          def fixed?
            options.key?(:fixed)
          end

          def required?
            options[:count] == :one || options[:count] == :many
          end

          def multiple?
            return overrides[:multiple] if overrides.key?(:multiple)
            options[:count] == :many || options[:count] == :any
          end

          def plural
            @plural ||= name.to_s.pluralize.to_sym
          end

          def plural_writer
            @plural_writer ||= "#{plural}="
          end

          def numbers_equal?
            plural == name
          end

          def overridden_xmlns
            overrides[:xmlns]
          end

          def override(overrides)
            @overrides = overrides
            yield
            @overrides = {}
          end
        end

        class Attribute < Property
          DEFAULTS = {
            type: String,
            required: false,
            optional: true,
            xml: false
          }.freeze

          def node_type
            :attribute
          end

          def required?
            options[:required]
          end

          def xml?
            options[:xml]
          end

          def attribute_name
            @attribute_name ||= if xml?
                                  "xml:#{name}"
                                else
                                  options.delete(:as) { name }.to_s
                                end
          end
        end

        class Text < Property
          DEFAULTS = {
            type: String
          }.freeze

          def node_type
            :text
          end

          def required?
            options[:required]
          end
        end
      end
    end
  end
end
