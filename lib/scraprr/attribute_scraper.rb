module Scraprr
  class MissingAttributeError < StandardError; end

  class AttributeScraper
    attr_reader :name, :path, :required, :html, :regexp

    def initialize(name, opts = {})
      @name = name
      @path = opts[:path] || '/'
      @required = opts[:required]
      @html = opts[:html]
      @regexp = opts[:regexp]
    end

    def extract(node)
      element = node.search(path)
      value = html ?  element.inner_html : element.inner_text
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
