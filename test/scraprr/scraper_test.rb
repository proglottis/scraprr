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
      <Name>Beer3</Name>
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
        @scraper.attribute(:name, "Name")
        @scraper.attribute(:volume, "Volume")
        result = @scraper.extract
        result[0].must_equal({ :name => "Beer1", :volume => "330ml" })
        result[1].must_equal({ :name => "Beer2", :volume => "500ml" })
        result[2].must_equal({ :name => "Beer3", :volume => "375ml" })
      end
    end
  end
end
