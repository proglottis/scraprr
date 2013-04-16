module Scraprr
  class MissingAttributeError < StandardError; end

  class AttributeScraper
    attr_reader :path, :required, :html, :regexp

    def initialize(opts = {})
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
        raise MissingAttributeError.new 'has empty value'
      end
      value
    end
  end
end
