require 'test_helper'

describe Scraprr::AttributeScraper do
  describe "#extract" do
    describe ":path" do
      it "returns value at path in XML" do
        node = xml_trivial.search('//Products/Beers/Beer')[0]
        value = Scraprr::AttributeScraper.new(:name, :path => "Name").
          extract(node)
        value.must_equal "Beer1"
      end

      it "returns value at path in HTML" do
        node = html_composite.search('table tr')[1]
        value = Scraprr::AttributeScraper.new(:price, :path => './td[2]').
          extract(node)
        value.must_equal '10.0'
      end
    end

    describe ":required" do
      it "raises if required attribute is blank" do
        node = xml_trivial.search('//Products/Beers/Beer').last
        proc {
          Scraprr::AttributeScraper.new(:name, :path => "Name", :required => true).
            extract(node)
        }.must_raise(Scraprr::MissingAttributeError)
      end
    end

    describe ":html" do
      it "returns value at path including HTML" do
        node = html_composite.search('table tr')[1]
        value = Scraprr::AttributeScraper.new(:price,
          :path => './td[2]',
          :html => true
        ).extract(node)
        value.must_equal '10.0<br>'
      end
    end

    describe ":regexp" do
      it "returns value that matches regexp" do
        node = html_composite.search('table tr')[1]
        value = Scraprr::AttributeScraper.new(:name,
          :path => './td[1]',
          :regexp => /^(.*) -.*$/
        ).extract(node)
        value.must_equal 'Beer1'
      end

      it "returns value including HTML that matches regexp" do
        node = html_composite.search('table tr')[1]
        result = Scraprr::AttributeScraper.new(:price,
          :path => './td[2]',
          :html => true,
          :regexp => /([0-9\.]+)/
        ).extract(node)
        result.must_equal '10.0'
      end
    end
  end
end
