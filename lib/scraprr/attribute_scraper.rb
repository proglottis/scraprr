module Scraprr
  class MissingAttributeError < StandardError; end

  class AttributeScraper
    attr_reader :name, :path, :attr, :required, :html, :regexp

    def initialize(name, opts = {})
      @name = name
      @path = opts[:path] || '/'
      @attr = opts[:attr]
      @required = opts[:required]
      @html = opts[:html]
      @regexp = opts[:regexp]
    end

    def extract(node)
      element = node.search(path)
      if attr
        value = element.attr(attr).to_s
      else
        value = html ?  element.inner_html : element.inner_text
      end
      if regexp
        match = regexp.match(value)
        value = match ? match[1] : nil
      end
      if required && (value == nil || value == '')
        raise MissingAttributeError.new "#{name} has empty value"
      end
      value
    end

    def eql?(other)
      name.eql?(other.name)
    end

    def hash
      name.hash
    end
  end
end
