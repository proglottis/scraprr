module Scraprr
  class Scraper
    attr_reader :root_path, :object_scraper

    def initialize(root_path = '/')
      @root_path = root_path
      @object_scraper = ObjectScraper.new
    end

    def root(path)
      @root_path = path
      self
    end

    def attribute(name, opts={})
      @object_scraper.attribute(name, opts)
      self
    end

    def extract(document)
      items = []
      document.search(root_path).each do |node|
        extract_item_into(items, node)
      end
      items
    end

    private

    def extract_item_into(items, node)
      items << @object_scraper.extract(node)
    rescue MissingAttributeError
      # skip
    end

  end
end
