# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

module NamespacedModule
  include Xommelier::Xml

  xmlns 'http://example.org/'

  class RootWithText < Xommelier::Xml::Element
    text
  end

  class RootWithSimpleSubelement < Xommelier::Xml::Element
    element :some
  end

  class RootWithAttribute < Xommelier::Xml::Element
    attribute :one, type: Date
    attribute :another
  end

  class RootWithManySimpleSubelements < Xommelier::Xml::Element
    element :foo, count: :many
  end

  class RootWithSubelement < Xommelier::Xml::Element
    attribute :one, type: Date
    attribute :two
    element :some
    element :another, type: RootWithSimpleSubelement
  end
end
