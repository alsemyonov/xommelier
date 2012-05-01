require 'xommelier/atom'

module Xommelier
  module Atom
    # Implements Feed Paging and Archiving
    # See RFC 5005 {http://tools.ietf.org/html/rfc5005.html}
    module History
      include Xommelier::Xml

      xmlns 'http://purl.org/syndication/history/1.0', as: :fh

      class Complete < Xml::Element; end
      class Archive < Xml::Element; end
    end

    class Feed
      may do
        element :complete, type: History::Complete
        element :archive, type: History::Archive
      end

      alias complete? complete
      alias archive? archive

      %w(first last previous next
         prev-archive next-archive current).each do |rel|
        define_method(:"#{rel.underscore}_feed_url") do
          links.find { |link| link.rel == rel && link.type == 'application/atom+xml' }.try(:href)
        end
      end
    end
  end
end
