module Scraprr
  class Scraper
    attr_reader :document, :attributes
    attr_accessor :root_matcher

    def initialize(document)
      @document = document
      @attributes = {}
    end

    def attribute(name, matcher)
      @attributes[name] = matcher
    end

    def extract
      document.search(root_matcher).map do |node|
        attributes.reduce({}) do |memo, (name, matcher)|
          memo[name] = node.search(matcher).first.content
          memo
        end
      end
    end
  end
end
