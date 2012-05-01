require 'xommelier/xml/schema'
require 'active_support/core_ext/module/delegation'

module Xommelier
  module Xml
    class Schema
      # OPTIMIZE use ruby +Module+ to provide group functionality
      class Group
        attr_accessor :schema
        delegate :ns, :namespace, to: :schema
        delegate :each, :[], to: :fields

        def initialize(options={}, &block)
          self.options = options
          instance_eval(&block) if block_given?
        end

        def options(options=nil)
          @options ||= {}
          if options
            @schema = options.delete(:schema) if options[:schema]
            @options.merge!(options)
          end
          @options
        end
        alias options= options
      end
    end
  end
end
