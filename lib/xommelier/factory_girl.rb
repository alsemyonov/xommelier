# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Authors: Sergey Ukustov <sergey@ukstv.me>    #
#          Alexander Semyonov <al@semyonov.us> #
################################################

require 'xommelier'
require 'factory_girl'

module Xommelier
  class XmlStrategy
    def initialize
      @strategy = FactoryGirl.strategy_by_name(:build).new
    end

    def result(evaluation)
      @strategy.result(evaluation).to_xml
    end
  end
end

FactoryGirl.register_strategy(:xml, Xommelier::XmlStrategy)
