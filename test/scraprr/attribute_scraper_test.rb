require 'test_helper'

describe Scraprr::AttributeScraper do
  describe "#extract" do
    describe ":path" do
      it "returns value at path in XML" do
        node = xml_trivial.search('//Products/Beers/Beer')[0].search("Name")
        value = Scraprr::AttributeScraper.new(:name, "Name").
          extract(node)
        value.must_equal "Beer1"
      end

      it "returns value at path in HTML" do
        node = html_composite.search('table tr')[1].search('./td[2]')
        value = Scraprr::AttributeScraper.new(:price, './td[2]').
          extract(node)
        value.must_equal '10.0'
      end
    end

    describe ":attr" do
      it "returns value in attribute at path" do
        node = xml_trivial.search('//Products/Beers/Beer')[0]
        value = Scraprr::AttributeScraper.new(:name, ".", :attr => "region").
          extract(node)
        value.must_equal "New Zealand"
      end

      it "returns empty in missing attribute at path" do
        node = xml_trivial.search('//Products/Beers/Beer')[0].search("Name")
        value = Scraprr::AttributeScraper.new(:name, "Name", :attr => "something").
          extract(node)
        value.must_equal ""
      end
    end

    describe ":required" do
      it "raises if required attribute is blank" do
        node = xml_trivial.search('//Products/Beers/Beer').last.search("Name")
        proc {
          Scraprr::AttributeScraper.new(:name, "Name", :required => true).
            extract(node)
        }.must_raise(Scraprr::MissingAttributeError)
      end
    end

    describe ":html" do
      it "returns value at path including HTML" do
        node = html_composite.search('table tr')[1].search("./td[2]")
        value = Scraprr::AttributeScraper.new(:price, './td[2]',
          :html => true
        ).extract(node)
        value.must_equal '10.0<br>'
      end
    end

    describe ":regexp" do
      it "returns value that matches regexp" do
        node = html_composite.search('table tr')[1].search("./td[1]")
        value = Scraprr::AttributeScraper.new(:name, './td[1]',
          :regexp => /^(.*) -.*$/
        ).extract(node)
        value.must_equal 'Beer1'
      end

      it "returns value including HTML that matches regexp" do
        node = html_composite.search('table tr')[1].search("./td[2]")
        result = Scraprr::AttributeScraper.new(:price, './td[2]',
          :html => true,
          :regexp => /([0-9\.]+)/
        ).extract(node)
        result.must_equal '10.0'
      end
    end

    describe ":strip" do
      it "returns value stripped of trailing and leading whitespace" do
        node = xml_trivial.search('//Products/Beers/Beer')[2].search("Name")
        value = Scraprr::AttributeScraper.new(:name, "Name", :strip => true).
          extract(node)
        value.must_equal 'Beer3'
      end
    end
  end
end
