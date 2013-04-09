module Scraprr
  class Scraper
    attr_reader :root_matcher, :attributes

    def initialize(root_matcher = '/')
      @root_matcher = root_matcher
      @attributes = {}
    end

    def root(matcher)
      @root_matcher = matcher
      self
    end

    def attribute(name, opts={})
      @attributes[name] = opts
      self
    end

    def extract(document)
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
