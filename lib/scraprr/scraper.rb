module Scraprr
  class Scraper
    attr_reader :document, :root_matcher, :attributes, :sanitizers

    def initialize(document)
      @document = document
      @attributes = {}
      @sanitizers = {}
    end

    def root(matcher)
      @root_matcher = matcher
      self
    end

    def attribute(name, opts={})
      @attributes[name] = opts
      self
    end

    def extract
      items = []
      document.search(root_matcher).each do |node|
        item = extract_item(node)
        items << item unless item[:_skip]
      end
      items
    end

    private

    def extract_item(node)
      item = {}
      attributes.each do |name, opts|
        next unless opts.has_key?(:matcher)
        element = node.search(opts[:matcher])
        value = opts[:html] ?  element.inner_html : element.inner_text
        if opts.has_key?(:regexp)
          match = opts[:regexp].match(value)
          value = match ? match[1] : nil
        end
        item[name] = value
        item[:_skip] = true if opts[:required] && (value == nil || value == "")
      end
      item
    end
  end
end
