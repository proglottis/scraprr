module Scraprr
  class ObjectScraper
    attr_reader :attributes

    def initialize
      @attributes = Set.new
    end

    def attribute(name, path=AttributeScraper::DEFAULT_PATH, opts={})
      @attributes.add(AttributeScraper.new(name, path, opts))
      self
    end

    def extract(node)
      attributes.reduce({}) do |item, attribute_scraper|
        element = node.search(attribute_scraper.path)
        item[attribute_scraper.name] = attribute_scraper.extract(element)
        item
      end
    end

  end
end
