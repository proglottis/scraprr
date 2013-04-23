module Scraprr
  class RegexpFilter
    def initialize(chain, regexp)
      @chain = chain
      @regexp = regexp
    end

    def run(value)
      match = @regexp.match(@chain.run(value))
      if match
        match[1]
      end
    end
  end
end
