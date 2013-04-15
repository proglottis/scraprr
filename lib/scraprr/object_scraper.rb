module Scraprr
  class ObjectScraper
    attr_reader :attributes

    def initialize
      @attributes = {}
    end

    def attribute(name, opts={})
      @attributes[name] = opts
      self
    end

    def extract(node)
      item = {}
      attributes.each do |name, opts|
        element = node.search(opts[:path])
        value = opts[:html] ?  element.inner_html : element.inner_text
        if opts.has_key?(:regexp)
          match = opts[:regexp].match(value)
          value = match ? match[1] : nil
        end
        item[name] = value
        return nil if opts[:required] && (value == nil || value == "")
      end
      item
    end

  end
end
