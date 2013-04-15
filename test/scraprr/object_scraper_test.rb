require 'test_helper'

describe Scraprr::ObjectScraper do
  describe "#extract" do
    describe ":path" do
      it "returns hash of attributes in XML" do
        node = xml_trivial.search('//Products/Beers/Beer')[0]
        result = Scraprr::ObjectScraper.new.
          attribute(:name, :path => "Name").
          attribute(:volume, :path => "Volume").
          extract(node)
        result.must_equal({ :name => 'Beer1', :volume => '330ml'})
      end

      it "returns hash of attributes in HTML" do
        node = html_composite.search('table tr')[1]
        result = Scraprr::ObjectScraper.new.
          attribute(:name, :path => './td[1]').
          attribute(:price, :path => './td[2]').
          extract(node)
        result.must_equal({ :name => 'Beer1 - 5%, 330ml', :price => '10.0'})
      end
    end

    describe ":required" do
      it "returns nil if required attribute is blank" do
        node = xml_trivial.search('//Products/Beers/Beer').last
        result = Scraprr::ObjectScraper.new.
          attribute(:name, :path => "Name", :required => true).
          extract(node)
        result.must_equal nil
      end
    end

    describe ":html" do
      it "returns attribute text including html" do
        node = html_composite.search('table tr')[1]
        result = Scraprr::ObjectScraper.new.
          attribute(:price, :path => './td[2]', :html => true).
          extract(node)
        result.must_equal({ :price => '10.0<br>'})
      end
    end

    describe ":regexp" do
      it "returns attribute text that matches regexp" do
        node = html_composite.search('table tr')[1]
        result = Scraprr::ObjectScraper.new.
          attribute(:name,   :path => './td[1]', :regexp => /^(.*) -.*$/).
          extract(node)
        result.must_equal({ :name => 'Beer1'})
      end

      it "returns attribute html that matches regexp" do
        node = html_composite.search('table tr')[1]
        result = Scraprr::ObjectScraper.new.
          attribute(:price, :path => './td[2]', :html => true, :regexp => /([0-9\.]+)/).
          extract(node)
        result.must_equal({ :price => '10.0' })
      end
    end
  end
end
