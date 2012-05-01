require 'xommelier/xml/schema/type'

module Xommelier
  module Xml
    class Schema
      class Type
        class << self
          def restriction(options={}, &block)
            options[:base] ||= superclass
            @restriction ||= Restriction.new(options)
            @restriction.instance_eval(&block) if block_given?
            @restriction
          end
          alias restrictions restriction
        end

        protected

        def restrict_value_of(string)
          if string.is_a?(String)
            self.class.restrictions.apply!(string)
          else
            string
          end
        end

        class Restriction
          attr_reader :base

          def initialize(restrictions = {})
            @restrictions = {}
            self.base = restrictions.delete(:base) if restrictions[:base]
            @restrictions.merge!(restrictions)
          end

          def base=(klass)
            @base = klass
          end

          def restrictions
            @restrictions ||= {}
          end

          def all
            if base.respond_to?(:restrictions)
              base.restrictions.all.merge(restrictions)
            else
              restrictions
            end
          end

          def apply!(string)
            if white_space
              process = white_space.is_a?(Array) ? white_space.first : white_space
              string = case process
                       when :replace
                         string.gsub(/\s/, ' ')
                       when :collapse
                         string.gsub(/\s+/, ' ').strip
                       when :preserve
                         string
                       else
                         raise "Unkown whiteSpace restriciton value: #{process}"
                       end
            end
            string
          end

          def method_missing(method, *args)
            #$stderr.puts "Method missing: #{method}(#{args.map(&:inspect).join(', ')})"
            self.class.send(:define_method, method) do |*args|
              if args.any?
                restrictions[method] = args.size > 1 ? args : args.first
              end
              all[method]
            end
            if args.any?
              restrictions[method] = args.size > 1 ? args : args.first
            end
            all[method]
          end
        end
      end
    end
  end
end
