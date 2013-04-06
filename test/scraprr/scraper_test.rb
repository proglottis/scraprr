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
        @scraper.root_matcher = "//Products/Beers/Beer"
        result = @scraper.extract
        result.length.must_equal 3
      end

      it "finds hash of attributes" do
        @scraper.root_matcher = "//Products/Beers/Beer"
        @scraper.attribute(:name, :matcher => "Name")
        @scraper.attribute(:volume, :matcher => "Volume")
        result = @scraper.extract
        result[0].must_equal({ :name => "Beer1", :volume => "330ml" })
        result[1].must_equal({ :name => "Beer2", :volume => "500ml" })
        result[2].must_equal({ :name => "", :volume => "375ml" })
      end

      it "uses sanitizer defined on attribute" do
        @scraper.root_matcher = "//Products/Beers/Beer"
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
        @scraper.root_matcher = "//Products/Beers/Beer"
        @scraper.attribute(:name, :matcher => "Name", :required => true)
        @scraper.extract.length.must_equal 2
      end

      it "skips when required attribute is blank after sanitizer" do
        @scraper.root_matcher = "//Products/Beers/Beer"
        @scraper.attribute(:name, :matcher => "Name", :required => true)
        @scraper.sanitizer(:name) do |name|
          ""
        end
        @scraper.extract.length.must_equal 0
      end
    end
  end
end
