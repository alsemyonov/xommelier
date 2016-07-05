# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier'
require 'xommelier/common'

module Xommelier
  module OPML
    include Xommelier::Xml

    # @!group Simple Types

    class Category < Array
      def self.from_xommelier(value)
        new(value.split('/'))
      end

      def category?
        [0].nil?
      end

      def tag?
        !category?
      end

      def to_xommelier
        join('/')
      end
    end

    class CategoryArray < Array
      def self.from_xommelier(value)
        new(value.to_s.split(',').map { |category| Category.from_xommelier(category) })
      end

      def to_xommelier
        map(&:to_xommelier).join(',')
      end
    end

    # @!group Complex Types

    class Element < Xml::Element
      def self.element(name, options = {})
        options[:as] ||= name.to_s.camelize(:lower)
        super(name, options)
      end

      def self.attribute(name, options = {})
        options[:as] ||= name.to_s.camelize(:lower)
        super(name, options)
      end
    end

    class Head < Element
      may do
        element :title
        element :date_created, type: Common::Time822
        element :date_modified, type: Common::Time822
        element :owner_name
        element :owner_email
        element :owner_id
        element :docs
        # element :expansionState
        # element :vertScrollState
        # element :windowTop
        # element :windowLeft
        # element :windowBottom
        # element :windowRight
      end
    end

    class Outline < Element
      attribute :text

      may do
        # Common
        attribute :type
        attribute :is_comment, type: Boolean, default: false
        attribute :is_breakpoint, type: Boolean, default: false
        attribute :created, type: Common::Time822
        attribute :category, type: CategoryArray
        # Subscriptions
        attribute :xml_url
        attribute :html_url
        attribute :description
        attribute :language
        attribute :version
        # Links
        attribute :url
      end

      any do
        element :outline, type: Outline
      end

      def each_outline(&block)
        yield(self)
        outlines.each do |outline|
          outline.each_outline(&block)
        end
      end
    end

    class Body < Element
      many do
        element :outline, type: Outline
      end

      def each_outline(&block)
        outlines.each do |outline|
          outline.each_outline(&block)
        end
      end
    end

    class Opml < Element
      attribute :version, default: '2.0'

      element :head, type: Head
      element :body, type: Body
    end
  end
end
