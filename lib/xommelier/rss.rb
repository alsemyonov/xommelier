require 'xommelier'
require 'xommelier/common'

module Xommelier
  # http://www.rssboard.org/rss-specification
  module RSS
    include Xommelier::Xml

    # TODO RSS Email simple type if needed
    # class EmailAddress < String
    # end

    class Element < Xml::Element
      def self.element(name, options = {})
        options[:as] ||= name.to_s.camelcase(:lower)
        super
      end

      def self.attribute(name, options = {})
        options[:as] ||= name.to_s.camelcase(:lower)
        super
      end
    end

    class Category < Element
      attribute :domain
      text
    end

    # Specifies a web service that supports the rssCloud interface which can be implemented
    #  in HTTP-POST, XML-RPC or SOAP 1.1.
    # Its purpose is to allow processes to register with a cloud to be notified of updates to the channel,
    #  implementing a lightweight publish-subscribe protocol for RSS feeds.
    class Cloud < Element
      attribute :domain
      attribute :port, type: Integer
      attribute :path
      attribute :register_procedure
      attribute :protocol # in: %w(xml-rpc http-post soap)
    end

    class Image < Element
      # The URL of the image file.
      element :url, type: Uri

      # Describes the image, it's used in the ALT attribute of the HTML <img> tag when the channel is rendered in HTML.
      element :title

      # The URL of the site, when the channel is rendered, the image is a link to the site. (Note, in practice the image <title> and <link> should have the same value as the channel's <title> and <link>.
      element :link, type: Uri

      may do
        # The width of the image in pixels.
        element :width, type: Integer, default: 88#, max: 144

        # The height of the image in pixels.
        element :height, type: Integer, default: 31#, max: 400

        # Text that is included in the TITLE attribute of the link formed around the image in the HTML rendering.
        element :description
      end
    end

    # NOTE Ignore it. Nothing useful. Really
    class TextInput < Element
    end

    class SkipHoursList < Element
      any do
        # A time in GMT when aggregators should not request the channel data.
        # The hour beginning at midnight is hour zero.
        element :hour, type: Integer#, in: 0..23
      end
    end

    class SkipDaysList < Element
      any do
        # A day when aggregators should not request the channel data.
        element :day# in: %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
      end
    end

    class Enclosure < Element
      # URL where the enclosure is located
      attribute :url, type: Uri

      # Size in bytes
      attribute :length, type: Integer

      # MIME media-type of the enclosure
      attribute :type

      text
    end

    class Guid < Element
      attribute :permalink, as: 'isPermaLink', type: Boolean, count: :may

      text
    end

    # TODO RSS Source complex type
    class Source < Element
      attribute :url, type: Uri

      text
    end

    # An item may represent a "story" -- much like a story in a newspaper or magazine;
    #  if so its description is a synopsis of the story, and the link points to the full story.
    # An item may also be complete in itself,
    #  if so, the description contains the text (entity-encoded HTML is allowed),
    #  and the link and title may be omitted.
    class Item < Element
      # guid or permalink URL for this entry
      element :guid, type: Guid

      # The title of the item.
      element :title

      # The item synopsis.
      element :description

      # The URL of the item.
      element :link, type: Uri

      # Email address of the author of the item.
      element :author#, type: EmailAddress

      # Includes the item in one or more categories.
      element :category, type: Category, count: :any

      # URL of a page for comments relating to the item.
      element :comments, type: Uri, count: :may

      # Describes a media object that is attached to the item.
      element :enclosure, type: Enclosure, count: :any

      # Indicates when the item was published.
      element :pub_date, type: Common::Time822

      # The RSS channel that the item came from.
      element :source, type: Source
    end

    class Channel < Element
      # The name of the channel. It's how people refer to your service.
      # If you have an HTML website that contains the same information as your RSS file,
      # the title of your channel should be the same as the title of your website.
      element :title

      # The URL to the HTML website corresponding to the channel.
      element :link, type: Uri #, type: XS::AnyUri

      # Phrase or sentence describing the channel.
      element :description

      may do
        # The language the channel is written in. This allows aggregators to group all Italian language sites,
        # for example, on a single page.
        element :language #, type: XS::Language

        # Copyright notice for content in the channel.
        element :copyright

        # Email address for person responsible for editorial content.
        element :managing_editor#, type: EmailAddress

        # Email address for person responsible for technical issues relating to channel.
        element :web_master#, type: EmailAddress

        # The publication date for the content in the channel.
        # All date-times in RSS conform to the Date and Time Specification of RFC 822, with the exception
        # that the year may be expressed with two characters or four characters (four preferred).
        element :pub_date, type: Common::Time822

        # The last time the content of the channel changed.
        element :last_build_date, type: Common::Time822
      end

      # Specify one or more categories that the channel belongs to.
      element :category, type: Category, count: :any

      may do
        # A string indicating the program used to generate the channel.
        element :generator

        # A URL that points to the documentation for the format used in the RSS file.
        # It's probably a pointer to http://www.rssboard.org/rss-specification.
        # It's for people who might stumble across an RSS file on a Web server 25 years from now and wonder what it is.
        element :docs

        # Allows processes to register with a cloud to be notified of updates to the channel,
        # implementing a lightweight publish-subscribe protocol for RSS feeds.
        element :cloud, type: Cloud

        # time to live. It's a number of minutes that indicates how long a channel can be cached
        # before refreshing from the source.
        element :ttl, type: Integer

        # Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
        element :image, type: Image

        # The PICS rating for the channel.
        element :rating

        # Specifies a text input box that can be displayed with the channel.
        element :text_input, type: TextInput

        # A hint for aggregators telling them which hours they can skip.
        element :skip_hours, type: SkipHoursList

        # A hint for aggregators telling them which days they can skip.
        element :skip_days, type: SkipDaysList
      end

      many do
        element :item, type: Item
      end
    end

    class Rss < Element
      attribute :version, default: '2.0', required: true

      element :channel, type: Channel, default: {}

      #noinspection RubyResolve
      def method_missing(method_name, *args)
        if channel.respond_to?(method_name) then
          channel.send(method_name, *args)
        else
          super
        end
      end
    end
  end
end
