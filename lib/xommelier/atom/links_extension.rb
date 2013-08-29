# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    module LinksExtension
      def feed_url
        detect_linked_href(rel: 'self', type: 'application/atom+xml')
      end

      def html_url
        detect_linked_href(rel: 'alternate', type: 'text/html')
      end

      protected

      def detect_linked_href(attributes = {})
        links.detect do |link|
          attributes.inject(true) do |result, (attr, value)|
            result && link.send(attr) == value
          end
        end.try(:href)
      end
    end
  end
end
