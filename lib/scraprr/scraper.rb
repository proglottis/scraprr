module Scraprr
  class Scraper
    attr_reader :document, :attributes, :sanitizers
    attr_accessor :root_matcher

    def initialize(document)
      @document = document
      @attributes = {}
      @sanitizers = {}
    end

    def attribute(name, opts={})
      @attributes[name] = opts
    end

    def sanitizer(name, &block)
      @sanitizers[name] = block
    end

    def extract
      items = []
      document.search(root_matcher).each do |node|
        skip = false
        item = {}
        attributes.each do |(name, opts)|
          value = node.search(opts[:matcher]).first.content
          if sanitizers.has_key?(name)
            value = sanitizers[name].call(value)
          end
          if opts[:required] && (!value || value == "")
            skip = true
            break
          end
          item[name] = value
        end
        items << item unless skip
      end
      items
    end
  end
end
