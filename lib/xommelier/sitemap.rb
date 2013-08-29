# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/xml'

module Xommelier
  # XML Schema for Sitemap files.
  module Sitemap
    include Xommelier::Xml

    class Element < Xml::Element
    end

    # Container for the data needed to describe a document to crawl.
    class Url < Element
      # REQUIRED: The location URI of a document.
      # The URI must conform to RFC 2396 (http://www.ietf.org/rfc/rfc2396.txt).
      element :loc, type: Url

      # OPTIONAL: The date the document was last modified. The date must conform
      # to the W3C DATETIME format (http://www.w3.org/TR/NOTE-datetime).
      # Example: 2005-05-10
      # Lastmod may also contain a timestamp.
      # Example: 2005-05-10T17:33:30+08:00
      element :lastmod, type: Time, count: :may

      # tChangeFreq
      # OPTIONAL: Indicates how frequently the content at a particular URL is
      # likely to change. The value "always" should be used to describe
      # documents that change each time they are accessed. The value "never"
      # should be used to describe archived URLs. Please note that web
      # crawlers may not necessarily crawl pages marked "always" more often.
      # Consider this element as a friendly suggestion and not a command.

      # %w(always hourly daily weekly monthly yearly never)
      element :changefreq, type: String, count: :may

      # OPTIONAL: The priority of a particular URL relative to other pages
      # on the same site. The value for this element is a number between
      # 0.0 and 1.0 where 0.0 identifies the lowest priority page(s).
      # The default priority of a page is 0.5. Priority is used to select
      # between pages on your site. Setting a priority of 1.0 for all URLs
      # will not help you, as the relative priority of pages on your site
      # is what will be considered.
      element :priority, type: Float, count: :may
    end

    # Container for a set of up to 50,000 document elements.
    # This is the root element of the XML file.
    class Urlset < Element
      element :url, type: Url, count: :many
    end
  end
end
