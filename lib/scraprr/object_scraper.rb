module Scraprr
  class MissingAttributeError < StandardError; end

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
      attributes.reduce({}) do |item, (name, opts)|
        item[name] = extract_attribute(opts, node)
        item
      end
    rescue MissingAttributeError
      nil
    end

    private

    def extract_attribute(opts, node)
      element = node.search(opts[:path])
      value = opts[:html] ?  element.inner_html : element.inner_text
      if opts.has_key?(:regexp)
        match = opts[:regexp].match(value)
        value = match ? match[1] : nil
      end
      if opts[:required] && (value == nil || value == "")
        raise MissingAttributeError.new
      end
      value
    end

  end
end
