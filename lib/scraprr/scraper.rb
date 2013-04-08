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

    def sanitizer(name, &block)
      @sanitizers[name] = block
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
        value = sanitize(name, opts[:html] ?  element.inner_html : element.inner_text)
        item[name] = value
        item[:_skip] = true if skip?(value, opts[:required])
      end
      attributes.each do |name, opts|
        next unless opts.has_key?(:in)
        match = opts[:regexp].match(item[opts[:in]])
        value = sanitize(name, match ? match[1] : nil)
        item[name] = value
        item[:_skip] = true if skip?(value, opts[:required])
      end
      attributes.each do |name, opts|
        next unless opts.has_key?(:composite)
        item.delete(name)
      end
      item
    end

    def skip?(value, required)
      required && (value == nil || value == "")
    end

    def sanitize(name, value)
      if sanitizers.has_key?(name) && value != nil
        value = sanitizers[name].call(value)
      end
      value
    end
  end
end
