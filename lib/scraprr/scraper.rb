module Scraprr
  class Scraper
    attr_reader :document, :attributes, :sanitizers
    attr_accessor :root_matcher

    def initialize(document)
      @document = document
      @attributes = {}
      @sanitizers = {}
    end

    def attribute(name, matcher)
      @attributes[name] = matcher
    end

    def sanitizer(name, &block)
      @sanitizers[name] = block
    end

    def extract
      document.search(root_matcher).map do |node|
        attributes.reduce({}) do |memo, (name, matcher)|
          memo[name] = node.search(matcher).first.content
          if sanitizers.has_key?(name)
            memo[name] = sanitizers[name].call(memo[name])
          end
          memo
        end
      end
    end
  end
end
