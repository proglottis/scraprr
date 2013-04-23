module Scraprr
  class StripFilter
    def initialize(chain)
      @chain = chain
    end

    def run(value)
      @chain.run(value).strip
    end
  end
end
