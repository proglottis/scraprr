require 'test_helper'

describe Scraprr::ValueExtractor do
  describe "#run" do
    it "returns value in plain text" do
      node = xml_trivial.search('//Products/Beers/Beer')[0].search("Name")
      value = Scraprr::ValueExtractor.new(nil, nil).run(node)
      value.must_equal "Beer1"
    end

    it "returns value in HTML" do
      node = html_composite.search('table tr')[1].search("./td[2]")
      value = Scraprr::ValueExtractor.new(nil, true).run(node)
      value.must_equal '10.0<br>'
    end

    it "returns value in attribute" do
      node = xml_trivial.search('//Products/Beers/Beer')[0]
      value = Scraprr::ValueExtractor.new("region", nil).run(node)
      value.must_equal "New Zealand"
    end

    it "returns empty in missing attribute" do
      node = xml_trivial.search('//Products/Beers/Beer')[0].search("Name")
      value = Scraprr::ValueExtractor.new("something", nil).run(node)
      value.must_equal ""
    end

    it "returns empty in attribute on missing node" do
      node = xml_trivial.search('//Products/Beers/Beer')[0].search("Something")
      value = Scraprr::ValueExtractor.new("region", nil).run(node)
      value.must_equal ""
    end
  end
end
