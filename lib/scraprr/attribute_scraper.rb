module Scraprr
  class MissingAttributeError < StandardError; end

  class AttributeScraper
    attr_reader :name, :path, :attr, :required, :html, :regexp, :strip

    DEFAULT_PATH = '.'

    def initialize(name, path = DEFAULT_PATH, opts = {})
      @name = name
      @path = path
      @attr = opts[:attr]
      @required = opts[:required]
      @html = opts[:html]
      @regexp = opts[:regexp]
      @strip = opts[:strip]
    end

    def extract(element)
      require_value(strip_value(regexp_value(extract_value(element))))
    end

    def eql?(other)
      name.eql?(other.name)
    end

    def hash
      name.hash
    end

    private

    def extract_value(element)
      if attr
        element.attr(attr).to_s
      else
        if html
          element.inner_html
        else
          element.inner_text
        end
      end
    end

    def regexp_value(value)
      return value unless regexp
      match = regexp.match(value)
      if match
        match[1]
      end
    end

    def strip_value(value)
      return value unless strip
      value.strip
    end

    def require_value(value)
      if required && (value == nil || value == '')
        raise MissingAttributeError.new "#{name} has empty value"
      end
      value
    end
  end
end
