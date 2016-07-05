# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier'

module Xommelier
  # Implements http://www.opensearch.org/Specifications/OpenSearch/1.1#Url_rel_values
  module OpenSearch
    MIME_TYPE = 'application/opensearchdescription+xml'

    include Xml

    xmlns 'http://a9.com/-/spec/opensearch/1.1/', as: :opensearch
    schema

    # @abstract
    class Element < Xml::Element
      def self.attribute(name, options = {})
        options[:as] ||= name.to_s.camelcase(:lower)
        super
      end

      def self.element(name, options = {})
        options[:as] ||= name.to_s.camelcase(:upper)
        super
      end

      class << self
        def find_element_name
          name.demodulize
        end
      end
    end

    class Url < Element
      attribute :template
      attribute :type

      may do
        attribute :rel, default: 'results' # may be results, suggestions, self, collection
        attribute :index_offset,  type: Integer, default: 1
        attribute :page_offset,   type: Integer, default: 1
      end
    end

    class Image < Element
      may do
        attribute :height, type: Integer
        attribute :width, type: Integer
        attribute :type
      end

      text type: Uri
    end

    class Query < Element
      attribute :role # , type: Enum[:request, :example, :related, :correction, :subset, :superset]

      may do
        attribute :title
        attribute :total_results, type: Integer
        attribute :search_terms, default: 'Xommelier'
        attribute :count, type: Integer
        attribute :start_index, type: Boolean
        attribute :start_page, type: Boolean
        attribute :language
        attribute :input_encoding
        attribute :output_encoding
      end
    end

    class Description < Element
      element_name 'OpenSearchDescription'

      element :short_name
      element :description

      element :url, type: Url, count: :many
      element :query, type: Query, count: :any

      may do
        element :tags
        element :contact
        element :long_name
        element :developer
        element :attribution
        element :syndication_right, type: String, default: 'open' # , type: Enum[:open, :limited, :private, :closed]
        element :adult_content, type: Boolean
        element :language, default: '*'
        element :input_encoding, default: 'UTF-8'
        element :output_encoding, default: 'UTF-8'
      end

      any do
        element :image, type: Image
      end
    end
  end

  if defined?(Atom)
    module Atom
      class Feed
        include LinksExtension

        may do
          element :total_results, type: Integer, ns: OpenSearch.xmlns, as: 'totalResults'
          element :start_index, type: Integer, ns: OpenSearch.xmlns, as: 'startIndex'
          element :items_per_page, type: Integer, ns: OpenSearch.xmlns, as: 'itemsPerPage'
        end

        any do
          element :query, type: OpenSearch::Query, as: OpenSearch::Query.element_name
        end

        def search_url
          detect_linked_href(rel: 'search', type: MIME_TYPE)
        end
      end
    end
  end
end
