require 'test_helper'

describe Scraprr::Scraper do
  describe "#extract" do
    describe "trivial XML" do
      before do
        xml = """
<Products>
  <Beers>
    <Beer>
      <Name>Beer1</Name>
      <Volume>330ml</Volume>
    </Beer>
    <Beer>
      <Name>Beer2</Name>
      <Volume>500ml</Volume>
    </Beer>
    <Beer>
      <Name></Name>
      <Volume>375ml</Volume>
    </Beer>
  </Beers>
</Products>
        """
        @document = Nokogiri::XML(xml)
        @scraper = Scraprr::Scraper.new('//Products/Beers/Beer')
      end

      it "finds each element at root path" do
        result = @scraper.extract(@document)
        result.length.must_equal 3
      end

      it "finds hash of attributes" do
        @scraper.
          attribute(:name, :path => "Name").
          attribute(:volume, :path => "Volume")
        result = @scraper.extract(@document)
        result[0].must_equal({ :name => "Beer1", :volume => "330ml" })
        result[1].must_equal({ :name => "Beer2", :volume => "500ml" })
        result[2].must_equal({ :name => "", :volume => "375ml" })
      end

      it "skips when required attribute is blank" do
        @scraper.attribute(:name, :path => "Name", :required => true)
        @scraper.extract(@document).length.must_equal 2
      end
    end

    describe "HTML with composite columns" do
      before do
        html = """
<html>
  <head></head>
  <body>
    <table>
      <tr><th>Beer</th><th>$</th></tr>
      <tr><td>Beer1 - 5%, 330ml</td><td>10.0<br></td></tr>
      <tr><td>Beer2 - 6%, 500ml</td><td>16.0<br></td></tr>
      <tr><td>Beer3 - 10%, 375ml</td><td>20.0<br></td></tr>
    </table>
  </body>
</html>
        """
        @document = Nokogiri::HTML(html)
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

      it "finds hash of attributes with HTML" do
        @scraper.attribute(:price, :path => './td[2]', :html => true)
        results = @scraper.extract(@document)
        results[0].must_equal({ :price => '' })
        results[1].must_equal({ :price => '10.0<br>' })
        results[2].must_equal({ :price => '16.0<br>' })
        results[3].must_equal({ :price => '20.0<br>' })
      end

      it "finds attributes based on regexp" do
        @scraper.
          attribute(:name,   :path => './td[1]', :regexp => /^(.*) -.*$/).
          attribute(:abv,    :path => './td[1]', :regexp => /^.*- (.*),.*$/).
          attribute(:volume, :path => './td[1]', :regexp => /^.*, (.*)$/)
        results = @scraper.extract(@document)
        results[0].must_equal({ :name => nil, :abv => nil, :volume => nil })
        results[1].must_equal({ :name => 'Beer1', :abv => '5%', :volume => '330ml' })
        results[2].must_equal({ :name => 'Beer2', :abv => '6%', :volume => '500ml' })
        results[3].must_equal({ :name => 'Beer3', :abv => '10%', :volume => '375ml' })
      end

      it "finds attributes based on regexp with HTML" do
        @scraper. attribute(:price, :path => './td[2]', :html => true, :regexp => /([0-9\.]+)/)
        results = @scraper.extract(@document)
        results[0].must_equal({ :price => nil })
        results[1].must_equal({ :price => '10.0' })
        results[2].must_equal({ :price => '16.0' })
        results[3].must_equal({ :price => '20.0' })
      end

    end
  end
end
