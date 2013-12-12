module Scraprr
  class StripFilter
    def initialize(chain)
      @chain = chain
    end

    def run(value)
      value = @chain.run(value)
      value.strip if value
    end
  end
end
