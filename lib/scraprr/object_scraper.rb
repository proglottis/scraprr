module Scraprr
  class ObjectScraper
    attr_reader :attributes

    def initialize
      @attributes = Set.new
    end

    def attribute(name, opts={})
      @attributes.add(AttributeScraper.new(name, opts))
      self
    end

    def extract(node)
      attributes.reduce({}) do |item, attribute_scraper|
        item[attribute_scraper.name] = attribute_scraper.extract(node)
        item
      end
    end

  end
end
