module Xommelier
  module Xml
    class Element
      module Structure
        module ClassMethods
          # Defines containing text
          def text(options = {})
            define_text_accessors
          end

          protected

          def define_text_accessors
            define_method(:text) do |*args|
              if args[0]
                write_text(args[0])
              end
              read_text
            end
            alias_method :text=, :text
          end
        end

        protected

        def text?
          respond_to?(:text)
        end

        def read_text
          @text
        end

        def write_text(text)
          @text = text
        end

        def remove_text
          @text = nil
        end
      end
    end
  end
end
