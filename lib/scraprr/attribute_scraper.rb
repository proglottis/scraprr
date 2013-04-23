module Scraprr
  class AttributeScraper
    attr_reader :name, :path, :required

    DEFAULT_PATH = '.'

    def initialize(name, path = DEFAULT_PATH, opts = {})
      @name = name
      @path = path
      @chain = build_chain(opts)
    end

    def build_chain(opts)
      chain = ValueExtractor.new(opts[:attr], opts[:html])
      chain = RegexpFilter.new(chain, opts[:regexp]) if opts[:regexp]
      chain = StripFilter.new(chain) if opts[:strip]
      chain = RequiredFilter.new(chain, opts[:name]) if opts[:required]
      chain
    end

    def extract(element)
      @chain.run(element)
    end

    def eql?(other)
      name.eql?(other.name)
    end

    def hash
      name.hash
    end
  end
end
