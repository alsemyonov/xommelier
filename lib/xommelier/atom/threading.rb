# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    # Implments Atom Threading Extensions
    # See RFC 4685 {http://tools.ietf.org/html/rfc4685.html}
    module Threading
      include Xommelier::Xml

      xmlns 'http://purl.org/syndication/thread/1.0', as: :thr

      class InReplyTo < Xml::Element
        element_name 'in-reply-to'

        attribute :ref

        may do
          attribute :href, type: Uri
          attribute :type, type: String
          attribute :source
        end
      end
    end

    # Extends Atom elements
    class Entry
      may do
        element :in_reply_to, type: Threading::InReplyTo, as: Threading::InReplyTo.element_name
        element :total, type: Integer, ns: Threading.xmlns
      end

      def replies_feed_url
        links.find { |link| link.rel == 'replies' && link.type == 'application/atom+xml' }.try(:href)
      end
    end

    class Link
      may do
        attribute :count,   type: Integer, ns: Threading.xmlns
        attribute :updated, type: Time,    ns: Threading.xmlns
      end
    end
  end
end
