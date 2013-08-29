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
