# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/atom'

module Xommelier
  module Atom
    class Entry < Xml::Element
      include LinksExtension

      element :id, unique: true
      element :title
      element :updated, type: Time

      may do
        element :content, type: Content
        element :published, type: Time
        element :rights
        element :source
        element :summary
      end

      any do
        element :author,      type: Person
        element :category,    type: Category
        element :contributor, type: Person
        element :link,        type: Link
      end
    end
  end
end
