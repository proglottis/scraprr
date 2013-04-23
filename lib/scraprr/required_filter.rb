module Scraprr
  class RequiredFilter
    def initialize(chain, name)
      @chain = chain
      @name = name
    end

    def run(value)
      value = @chain.run(value)
      if value == nil || value == ''
        raise MissingAttributeError.new "#{@name} has empty value"
      end
      value
    end
  end
end
