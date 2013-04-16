require 'test_helper'

describe Scraprr::Scraper do
  describe "#extract" do
    describe "XML document" do
      before do
        @document = xml_trivial
        @scraper = Scraprr::Scraper.new('//Products/Beers/Beer')
      end

      it "finds each element at root path" do
        result = @scraper.extract(@document)
        result.length.must_equal @document.search('//Products/Beers/Beer').length
      end

      it "finds hash of attributes" do
        @scraper.
          attribute(:name, :path => "Name").
          attribute(:volume, :path => "Volume")
        result = @scraper.extract(@document)
        result[0].must_equal({ :name => "Beer1", :volume => "330ml" })
        result[1].must_equal({ :name => "Beer2", :volume => "500ml" })
        result[2].must_equal({ :name => "  Beer3  ", :volume => "  440ml  " })
        result[3].must_equal({ :name => "", :volume => "375ml" })
      end

      it "skips item when required attribute is empty" do
        @scraper.
          attribute(:name, :path => "Name", :required => true).
          attribute(:volume, :path => "Volume")
        result = @scraper.extract(@document)
        result[0].must_equal({ :name => "Beer1", :volume => "330ml" })
        result[1].must_equal({ :name => "Beer2", :volume => "500ml" })
        result.length.must_equal @document.search('//Products/Beers/Beer').length - 1
      end
    end

    describe "HTML document" do
      before do
        @document = html_composite
        @scraper = Scraprr::Scraper.new("table tr")
      end

      it "finds each element at root path" do
        @scraper.extract(@document).length.must_equal 4
      end

      it "finds hash of attributes" do
        @scraper.
          attribute(:name, :path => './td[1]').
          attribute(:price, :path => './td[2]')
        results = @scraper.extract(@document)
        results[0].must_equal({ :name => '', :price => '' })
        results[1].must_equal({ :name => 'Beer1 - 5%, 330ml', :price => '10.0' })
        results[2].must_equal({ :name => 'Beer2 - 6%, 500ml', :price => '16.0' })
        results[3].must_equal({ :name => 'Beer3 - 10%, 375ml', :price => '20.0' })
      end
    end
  end
end
