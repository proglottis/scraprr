module Scraprr
  class ValueExtractor
    def initialize(attr, html)
      @attr = attr
      @html = html
    end

    def run(element)
      if @attr && element.first
        element.attr(@attr).to_s
      else
        if @html
          element.inner_html
        else
          element.inner_text
        end
      end
    end
  end
end
