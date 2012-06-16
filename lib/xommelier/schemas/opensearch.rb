require 'xommelier/xml/schema'

module Xommelier
  # Based on http://www.opensearch.org/Specifications/OpenSearch/1.1
  module Schemas
    module OpenSearch
      extend Xommelier::Xml::Schema::DSL

      schema :xmlns,
        xmlns: {
        xmlns: "http://a9.com/-/spec/opensearch/1.1/",
        mstns: "http://a9.com/-/spec/opensearch/1.1/",
        xs: "http://www.w3.org/2001/XMLSchema"
      }, elementFormDefault: "qualified"

      namespace "http://a9.com/-/spec/opensearch/1.1/", as: :xmlns
      element :OpenSearchDescription do
        complex_type do
          all do
            element :ShortName, min: 1, max: 1 do
              simple_type base: ns.xs.string, maximum: 16
            end
            # Contains a human-readable text description of the search engine.
            element :Desciption, min: 1, max: 1 do
              simple_type base: ns.xs.string, maximum: 1024
            end
            # Describes an interface by which a search client can make search requests of the search engine.
            # OpenSearch provides support for both index-based and page-based search engines. By default, both the first search result and the first page of search results are numbered "1". Search engines can use the "indexOffset" and "pageOffset" attributes to inform search clients of different starting values.
            element :Url, min: 1 do
              complex_type do
                # Contains the search URL template to be processed according to the OpenSearch URL template syntax.
                attribute :template, required: true
                # Contains the MIME type of the search result format.
                # Restrictions: The value must be a valid MIME type.
                attribute :type, required: true
                # Contains the index number of the first search result.
                attribute :indexOffset, simple_type: {base: ns.xs.integer}, required: false, default: "1"
                # Contains the page number of the first set of search results.
                attribute :pageOffset, simple_type: {base: ns.xs.integer}, required: false, default: "1"
              end
            end
            # Contains an email address at which the maintainer of the description document can be reached.
            # Restrictions: The value must conform to the requirements of Section 3.4.1 "Addr-spec specification" in RFC 2822.
            element :Contact, min: 0, max: 1
            # Contains a set of words that are used as keywords to identify and categorize this search content. Tags must be a single word and are delimited by the space character (' ').
            # Restriction: The value must not contain HTML or other markup.
            element :Tags, min: 0, max: 1 do
              simple_type base: ns.xs.string, maximum: 256
            end
            # Contains an extended human-readable title that identifies this search engine.
            # Search clients should use the value of the ShortName element if this element is not available.
            # Restrictions:  The value must not contain HTML or other markup.
            element :LongName, min: 0, max: 1 do
              simple_type base: ns.xs.string, maximum: 48
            end
            # Contains a URL that identifies the location of an image that can be used in association with this search content.
            # Image sizes are offered as a hint to the search client. The search client will chose the most appropriate image for the available space and should give preference to those listed first in the OpenSearch description document. Square aspect ratios are recommended. When possible, search engines should offer a 16x16 image of type "image/x-icon" or "image/vnd.microsoft.icon" (the Microsoft ICON format) and a 64x64 image of type "image/jpeg" or "image/png".
            # Restrictions: The value must be a URI.
            element :Image, min: 0 do
              complex_type do
                # Contains the height, in pixels, of this image.
                attribute :height, simple_type: {base: ns.xs.negativeInteger}, required: false
                # Contains the width, in pixels, of this image.
                attribute :width, simple_type: {base: ns.xs.nonNegativeInteger}, required: false
                # Contains the the MIME type of this image.
                # Restrictions: The value must be a valid MIME type.
                attribute :type, required: false
              end
            end
            # Defines a search query that can be performed by search clients. Please see the OpenSearch Query element specification for more information.
            # OpenSearch description documents should include at least one Query element of role="example" that is expected to return search results. Search clients may use this example query to validate that the search engine is working properly.
            element :Query, min: 0 do
              complex_type do
                # role - Contains a string identifying how the search client should interpret the search request defined by this Query element.
                # Role values: A role value consists of an optional prefix followed by the local role value. If the prefix is present it will be separated from the local role value with the ":" character. All role values are associated with a namespace, either implicitly in the case of local role values, or explicitly via a prefix in the case of fully qualified role values.
                # Role extensibility: The role attribute may take on values beyond those specified in this document provided they are fully qualified with a prefix and associated with a declared namespace. Clients that encounter unrecognized role values should continue to process the document as if the Query element containing the unrecognized role value did not appear.
                # Role prefix:  A role prefix associates a local role name with a namespace. All prefixes must be previously declared as an XML namespace prefix on the containing Query element or ancestor elements.
                # Local role values:   Local role values are not preceded by a prefix. Local role values are associated with the OpenSearch 1.1 namespace.
                # The following role values are identified with the OpenSearch 1.1 namespace. The list is exhaustive; only the role values listed below may appear in the OpenSearch 1.1 namespace.
                # Role values:
                attribute :role, simple_type: {base: ns.xs.string, enumeration: ["request", "example", "related", "correction", "subset", "superset"]}, required: true
                # Contains a human-readable plain text string describing the search request.
                attribute :title, simple_type: {base: ns.xs.string, maximum: 256}, required: false
                # Contains the expected number of results to be found if the search request were made.
                attribute :totalResults, simple_type: {base: ns.xs.nonNegativeInteger}, required: false
                # Contains the value representing the "searchTerms" as an OpenSearch 1.1 parameter.
                # Restrictions: The value must be URL-encoded.
                attribute :searchTerms, required: false
                # Contains the value representing the "count" as a OpenSearch 1.1 parameter.
                # Search clients should anticipate that the value of the "count" parameter may not be honored by the search engine, and should rely exclusively on the contents of the "itemsPerPage" response element in calculating actual page size.
                attribute :count, simple_type: {base: ns.xs.nonNegativeInteger}, required: false
                # Contains the value representing the "startIndex" as an OpenSearch 1.1 parameter.
                # Replaced with the index of the first search result desired by the search client.
                # Default: The value specified by the "indexOffset" attribute of the containing Url element.
                attribute :startIndex, simple_type: {base: ns.xs.integer}, required: false
                # Contains the value representing the "startPage" as an OpenSearch 1.1 parameter.
                # Replaced with the page number of the set of search results desired by the search client.
                # Default: The value specified by the "pageOffset" attribute of the containing Url element.
                attribute :startPage, simple_type: {base: ns.xs.integer}, required: false
                # Contains the value representing the "language" as an OpenSearch 1.1 parameter.
                # Replaced with a string that indicates that the search client desires search results in the specified language.
                # An OpenSearch description document should include one "Language" element for each language that the search engine supports. If the search engine also supports queries for any arbitrary language then the OpenSearch description document should include a Language element with a value of "*". The "language" template parameter in the OpenSearch URL template can be used to allow the search client to choose among the available languages.
                # Restrictions: The value must conform to the XML 1.0 Language Identification, as specified by RFC 3066. In addition, a value of "*" will signify that the search client desires search results in any language.
                attribute :language, required: false, default: "*"
                # Contains the value representing the "inputEncoding" as an OpenSearch 1.1 parameter.
                # Replaced with a string that indicates that the search client is performing the search request encoded with the specified character encoding.
                # An OpenSearch description document should include one "InputEncoding" element for each character encoding that can be used to encode search requests. The "inputEncoding" template parameter in the OpenSearch URL template can be used to require the search client to identify which encoding is being used to encode the current search request.
                # Restrictions: The value must conform to the XML 1.0 Character Encodings, as specified by the IANA Character Set Assignments.
                attribute :inputEncoding, required: false, default: "UTF-8"
                # Replaced with a string that indicates that the search client desires a search response encoding with the specified character encoding.
                # An OpenSearch description document should include one "OutputEncoding" element for each character encoding that can be used to encode search responses. The "outputEncoding" template parameter in the OpenSearch URL template can be used to allow the search client to choose a character encoding in the search response.
                # Restrictions: The value must conform to the XML 1.0 Character Encodings, as specified by the IANA Character Set Assignments.
                attribute :outputEncoding, required: false
              end
            end
            # Contains the human-readable name or identifier of the creator or maintainer of the description document.
            # The developer is the person or entity that created the description document, and may or may not be the owner, author, or copyright holder of the source of the content itself.
            # Restrictions:  The value must not contain HTML or other markup.
            element :Developer, min: 0, max: 1 do
              simple_type base: ns.xs.string, maximum: 64
            end
            # Contains a list of all sources or entities that should be credited for the content contained in the search feed.
            # Restrictions:  The value must not contain HTML or other markup.
            element :Attribution, min: 0, max: 1 do
              simple_type base: ns.xs.string, maximum: 256
            end
            # Contains a value that indicates the degree to which the search results provided by this search engine can be queried, displayed, and redistributed.
            element :SyndicationRight, min: 0, max: 1, default: "open" do
              simple_type base: ns.xs.string, enumeration: ["open", "limited", "private", "closed"]
            end
            # Contains a boolean value that should be set to true if the search results may contain material intended only for adults.
            # As there are no universally applicable guidelines as to what constitutes "adult" content, the search engine should make a good faith effort to indicate when there is a possibility that search results may contain material inappropriate for all audiences.
            # The values "false", "FALSE", "0", "no", and "NO" will be considered boolean FALSE; all other strings will be considered boolean TRUE.
            element :AdultContent, min: 0, max: 1, default: "false"
            # Contains a string that indicates that the search engine supports search results in the specified language.
            # An OpenSearch description document should include one "Language" element for each language that the search engine supports. If the search engine also supports queries for any arbitrary language then the OpenSearch description document should include a Language element with a value of "*". The "language" template parameter in the OpenSearch URL template can be used to allow the search client to choose among the available languages.
            # Restrictions: The value must conform to the XML 1.0 Language Identification, as specified by RFC 3066. In addition, the value of "*" will signify that the search engine does not restrict search results to any particular language.
            element :Language, min: 0, default: "*"
            # Contains a string that indicates that the search engine supports search requests encoded with the specified character encoding.
            # An OpenSearch description document should include one "InputEncoding" element for each character encoding that can be used to encode search requests. The "inputEncoding" template parameter in the OpenSearch URL template can be used to require the search client to identify which encoding is being used to encode the current search request.
            # Restrictions: The value must conform to the XML 1.0 Character Encodings, as specified by the IANA Character Set Assignments.
            element :InputEncoding, min: 0, default: "UTF-8"
            # Contains a string that indicates that the search engine supports search responses encoded with the specified character encoding.
            # An OpenSearch description document should include one "OutputEncoding" element for each character encoding that can be used to encode search responses. The "outputEncoding" template parameter in the OpenSearch URL template can be used to allow the search client to choose a character encoding in the search response.
            # Restrictions: The value must conform to the XML 1.0 Character Encodings, as specified by the IANA Character Set Assignments.
            element :OutputEncoding, min: 0, default: "UTF-8"
          end
        end
      end
    end
  end
end
