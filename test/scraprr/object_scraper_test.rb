require 'test_helper'

describe Scraprr::ObjectScraper do
  describe "#extract" do
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

    it "raises if required attribute is blank" do
      node = xml_trivial.search('//Products/Beers/Beer').last
      proc {
        Scraprr::ObjectScraper.new.
          attribute(:name, :path => "Name", :required => true).
          extract(node)
      }.must_raise(Scraprr::MissingAttributeError)
    end
  end
end
