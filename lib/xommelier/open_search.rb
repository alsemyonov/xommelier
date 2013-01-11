require 'xommelier'

module Xommelier
  # Implements http://www.opensearch.org/Specifications/OpenSearch/1.1#Url_rel_values
  module OpenSearch
    MIME_TYPE = 'application/opensearchdescription+xml'

    include Xml

    xmlns 'http://a9.com/-/spec/opensearch/1.1/', as: :opensearch

    class Url < Xml::Element
      element_name :Url

      attribute :template
      attribute :type

      may do
        attribute :rel, default: 'results' # may be results, suggestions, self, collection
        attribute :index_offset,  type: Integer, default: 1
        attribute :page_offset,   type: Integer, default: 1
      end
    end

    class Image < Xml::Element
      element_name :Image

      may do
        attribute :height, type: Integer
        attribute :width, type: Integer
        attribute :type
      end

      text type: Uri
    end

    class Query < Xml::Element
      element_name :Query

      element :role#, type: Enum[:request, :example, :related, :correction, :subset, :superset]

      may do
        element :title
        element :total_results, type: Integer, as: 'totalResults'
        element :search_terms, as: 'searchTerms', default: 'Xommelier'
        element :count, type: Integer
        element :start_index, type: Boolean, as: 'startIndex'
        element :start_page, type: Boolean, as: 'startPage'
        element :language
        element :input_encoding, as: 'inputEncoding'
        element :output_encoding, as: 'outputEncoding'
      end
    end

    class Description < Xml::Element
      element_name :OpenSearchDescription

      element :short_name, as: :ShortName
      element :description, as: :Description

      many do
        element :url, type: Url, as: Url.element_name
      end

      may do
        element :tags,        as: :Tags
        element :contacts,    as: :Contacts
        element :long_name,   as: :LongName
        element :developer,   as: :Developer
        element :attribution, as: :Attribution
        element :syndication_right, type: Symbol, as: :SyndicatioeRight, default: :open #, type: Enum[:open, :limited, :private, :closed]
        element :adult_content, type: Boolean, as: :AdultContent
        element :language, as: :Language, default: '*'
        element :input_encoding, as: :InputEncoding, default: 'UTF-8'
        element :output_encoding, as: :OutputEncoding, default: 'UTF-8'
      end

      any do
        element :image, type: Image, as: Image.element_name
      end
    end
  end

  if defined?(Atom)
    module Atom
      class Feed
        may do
          element :totalResults, type: Integer, ns: OpenSearch.xmlns
          element :startIndex, type: Integer, ns: OpenSearch.xmlns
          element :itemsPerPage, type: Integer, ns: OpenSearch.xmlns
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
