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
        doc = Nokogiri::XML(xml)
        @scraper = Scraprr::Scraper.new(doc)
      end

      it "finds each element at root matcher" do
        @scraper.root "//Products/Beers/Beer"
        result = @scraper.extract
        result.length.must_equal 3
      end

      it "finds hash of attributes" do
        @scraper.root "//Products/Beers/Beer"
        @scraper.attribute(:name, :matcher => "Name")
        @scraper.attribute(:volume, :matcher => "Volume")
        result = @scraper.extract
        result[0].must_equal({ :name => "Beer1", :volume => "330ml" })
        result[1].must_equal({ :name => "Beer2", :volume => "500ml" })
        result[2].must_equal({ :name => "", :volume => "375ml" })
      end

      it "uses sanitizer defined on attribute" do
        @scraper.root "//Products/Beers/Beer"
        @scraper.attribute(:volume, :matcher => "Volume")
        @scraper.sanitizer(:volume) do |volume|
          volume.strip.sub('ml', '').to_f
        end
        result = @scraper.extract
        result[0].must_equal({ :volume => 330.0 })
        result[1].must_equal({ :volume => 500.0 })
        result[2].must_equal({ :volume => 375.0 })
      end

      it "skips when required attribute is blank" do
        @scraper.root "//Products/Beers/Beer"
        @scraper.attribute(:name, :matcher => "Name", :required => true)
        @scraper.extract.length.must_equal 2
      end

      it "skips when required attribute is blank after sanitizer" do
        @scraper.root "//Products/Beers/Beer"
        @scraper.attribute(:name, :matcher => "Name", :required => true)
        @scraper.sanitizer(:name) do |name|
          ""
        end
        @scraper.extract.length.must_equal 0
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
        doc = Nokogiri::HTML(html)
        @scraper = Scraprr::Scraper.new(doc)
      end

      it "finds each element at root matcher" do
        @scraper.root "table tr"
        @scraper.extract.length.must_equal 4
      end

      it "finds hash of attributes" do
        @scraper.root "table tr"
        @scraper.attribute(:name, :matcher => './td[1]')
        @scraper.attribute(:price, :matcher => './td[2]')
        results = @scraper.extract
        results[0].must_equal({ :name => '', :price => '' })
        results[1].must_equal({ :name => 'Beer1 - 5%, 330ml', :price => '10.0' })
        results[2].must_equal({ :name => 'Beer2 - 6%, 500ml', :price => '16.0' })
        results[3].must_equal({ :name => 'Beer3 - 10%, 375ml', :price => '20.0' })
      end

      it "finds hash of attributes with HTML" do
        @scraper.root "table tr"
        @scraper.attribute(:price, :matcher => './td[2]', :html => true)
        results = @scraper.extract
        results[0].must_equal({ :price => '' })
        results[1].must_equal({ :price => '10.0<br>' })
        results[2].must_equal({ :price => '16.0<br>' })
        results[3].must_equal({ :price => '20.0<br>' })
      end

      it "splits composite attributes" do
        @scraper.root "table tr"
        @scraper.attribute(:data, :matcher => './td[1]', :composite => true)
        @scraper.attribute(:name, :in => :data, :regexp => /^(.*) -.*$/)
        @scraper.attribute(:abv, :in => :data, :regexp => /^.*- (.*),.*$/)
        @scraper.attribute(:volume, :in => :data, :regexp => /^.*, (.*)$/)
        results = @scraper.extract
        results[0].must_equal({ :name => nil, :abv => nil, :volume => nil })
        results[1].must_equal({ :name => 'Beer1', :abv => '5%', :volume => '330ml' })
        results[2].must_equal({ :name => 'Beer2', :abv => '6%', :volume => '500ml' })
        results[3].must_equal({ :name => 'Beer3', :abv => '10%', :volume => '375ml' })
      end

      it "skips when required composite attribute is blank" do
        @scraper.root "table tr"
        @scraper.attribute(:data, :matcher => './td[1]', :composite => true)
        @scraper.attribute(:name, :in => :data, :regexp => /^(.*) -.*$/, :required => true)
        @scraper.extract.length.must_equal 3
      end

      it "uses sanitizer defined on composite attribute" do
        @scraper.root "table tr"
        @scraper.attribute(:data, :matcher => './td[1]', :composite => true)
        @scraper.attribute(:volume, :in => :data, :regexp => /^.*, (.*)$/)
        @scraper.sanitizer(:volume) do |volume|
          volume.strip.sub('ml', '').to_f
        end
        result = @scraper.extract
        result[0].must_equal({ :volume => nil })
        result[1].must_equal({ :volume => 330.0 })
        result[2].must_equal({ :volume => 500.0 })
        result[3].must_equal({ :volume => 375.0 })
      end

    end
  end
end
