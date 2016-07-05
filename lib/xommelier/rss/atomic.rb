# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier/rss'
require 'xommelier/atom'
require 'xommelier/atom/history'

module Xommelier
  module RSS
    class Channel
      may do
        element :id, ns: Atom.xmlns
        element :complete, type: Atom::History::Complete
        element :archive, type: Atom::History::Archive
      end
      element :atom_link, type: Atom::Link, count: :any
    end

    class Item
      element :id, ns: Atom.xmlns, count: :may
      element :atom_link, type: Atom::Link, count: :any
    end
  end
end
