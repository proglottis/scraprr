module Scraprr
  class ObjectScraper
    attr_reader :attributes

    def initialize
      @attributes = {}
    end

    def attribute(name, opts={})
      @attributes[name] = AttributeScraper.new(opts)
      self
    end

    def extract(node)
      attributes.reduce({}) do |item, (name, attribute_scraper)|
        item[name] = attribute_scraper.extract(node)
        item
      end
    rescue MissingAttributeError
      nil
    end
  end
end
