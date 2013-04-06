module Scraprr
  class Scraper
    attr_reader :document, :attributes, :sanitizers
    attr_accessor :root_matcher

    def initialize(document)
      @document = document
      @attributes = {}
      @sanitizers = {}
    end

    def attribute(name, opts={})
      @attributes[name] = opts
    end

    def sanitizer(name, &block)
      @sanitizers[name] = block
    end

    def extract
      items = []
      document.search(root_matcher).each do |node|
        skip = false
        item = {}
        attributes.each do |name, opts|
          next unless opts.has_key?(:matcher)
          element = node.search(opts[:matcher]).first
          value = element ? element.content : nil
          if sanitizers.has_key?(name) && value != nil
            value = sanitizers[name].call(value)
          end
          if opts[:required] && (value == nil || value == "")
            skip = true
            break
          end
          item[name] = value
        end
        attributes.each do |name, opts|
          next unless opts.has_key?(:in)
          match = opts[:regexp].match(item[opts[:in]])
          value = match ? match[1] : nil
          if sanitizers.has_key?(name) && value != nil
            value = sanitizers[name].call(value)
          end
          if opts[:required] && (value == nil || value == "")
            skip = true
            break
          end
          item[name] = value
        end
        attributes.each do |name, opts|
          next unless opts.has_key?(:composite)
          item.delete(name)
        end
        items << item unless skip
      end
      items
    end
  end
end
