require 'xommelier/xml'
require 'active_support/core_ext/object/with_options'
require 'active_support/core_ext/array/extract_options'

module Xommelier
  module Xml
    Infinity = 1.0 / 0

    class Element
      attr_reader :name, :namespace, :elements, :attributes, :options, :as

      def initialize(name, options = {}, &block)
        @name           = name
        @elements       = []
        @attributes     = []
        @options        = {}
        @scope_options  = {}
        self.options    = {count: 1..1, root: false, type: nil, as: @name}.merge(options)
        scoped(&block) if block_given?
      end

      def ns
        Xommelier::Xml::Namespace.registry
      end

      def namespace=(namespace)
        @namespace = namespace
        @namespace.elements[name] = self
      end

      def options=(options)
        self.namespace  = options.delete(:ns) if options.key?(:ns)
        @type           = options.delete(:type) if options.key?(:type)
        @as             = options.delete(:as) if options.key?(:as)
        @options.merge!(options)
      end

      def scoped(&block)
        instance_exec(&block)
      end

      def element(*names, &block)
        @namespace.with_options @scope_options do |scope|
          scope.element(*names, &block).tap do |elements|
            @elements += elements
          end
        end
      end

      def attribute(*names)
        @namespace.with_options @scope_options do |scope|
          scope.attribute(*names).tap do |attribute|
            @attributes += attributes
          end
        end
      end

      def may(&block)
        old_scope, @scope_options = @scope_options, @scope_options.merge(count: 0..1)
        scoped(&block)
        @scope_options = old_scope
      end

      def any(&block)
        old_scope, @scope_options = @scope_options, @scope_options.merge(count: 0..Infinity)
        scoped(&block)
        @scope_options = old_scope
      end

      def inspect
        inspect_attributes = if attributes.any?
                               " #{attributes.map(&:inspect).join ' '}"
                             else
                               nil
                             end
        inspect_elements = if elements.any?
                             " #{elements.map(&:inspect).join(' ')} "
                           else
                             nil
                           end

        inspect_type = if @type.nil?
                         nil
                       else
                         @type.inspect
                       end
        inspect_count = if options[:count].eql? 0..1
                          '?'
                        elsif options[:count].eql? 0..Infinity
                          '*'
                        else
                          ''
                        end
        "<#{namespace.as}:#{as}#{inspect_attributes}" +
          (inspect_elements || inspect_type ? ">#{inspect_elements}#{inspect_type}</#{namespace.as}:#{as}>" : " />") +
          inspect_count
      end

      def root?
        options[:root]
      end

      protected
    end
  end
end
