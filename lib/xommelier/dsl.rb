module Xommelier
  module DSL
    def namespace(href, options, &block)
      namespace = Xommelier::Xml::Namespace.registry.key(href)
      if namespace
        namespace.scoped(&block)
      else
        namespace = Xommelier::Xml::Namespace.new(href, options, &block)
      end
      namespace
    end

    module Namespace
      def self.extend_object(mod)
        mod.send(:include, Xommelier::Xml)
        super
      end

      def ns
        Xommelier::Xml::Namespace.registry
      end

      def import(href, options)
        # TODO Xommelier::Xml::Namespace.import(href)
        $stderr.puts "#{xmlns}#import #{href.inspect}, #{options.inspect}"
      end

      def complex_type(name, options = {}, &block)
        # TODO define or reopen class
        $stderr.puts "#{xmlns}#complex_type #{name.inspect}, #{options.inspect}"
      end

      def group(name, options = {}, &block)
        # TODO define or reopen class
        $stderr.puts "#{xmlns}#complex_type #{name.inspect}, #{options.inspect}"
      end
    end
  end

  extend DSL
end
