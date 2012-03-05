require 'xommelier/atom'

module Xommelier
  module Atom
    module LinksExtension
      def feed_url
        links.find { |link| link.rel == 'self' && link.type == 'application/atom+xml' }.try(:href)
      end

      def html_url
        links.find { |link| link.rel == 'alternate' && link.type == 'text/html' }.try(:href)
      end
    end
  end
end
