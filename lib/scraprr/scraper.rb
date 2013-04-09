module Scraprr
  class Scraper
    attr_reader :root_path, :attributes

    def initialize(root_path = '/')
      @root_path = root_path
      @attributes = {}
    end

    def root(path)
      @root_path = path
      self
    end

    def attribute(name, opts={})
      @attributes[name] = opts
      self
    end

    def extract(document)
      items = []
      document.search(root_path).each do |node|
        item = extract_item(node)
        items << item unless item[:_skip]
      end
      items
    end

    private

    def extract_item(node)
      item = {}
      attributes.each do |name, opts|
        element = node.search(opts[:path])
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
