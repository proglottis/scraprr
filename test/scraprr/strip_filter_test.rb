require 'test_helper'

describe Scraprr::StripFilter do
  describe "#run" do
    before do
      @chain = MiniTest::Mock.new
    end

    it "strips leading/trailing whitespace from the value" do
      value = '  test  '
      @chain.expect(:run, value, [value])

      @chain = Scraprr::StripFilter.new(@chain)
      @chain.run(value).must_equal('test')
    end

    it "returns nil if value was nil" do
      value = nil
      @chain.expect(:run, value, [value])

      @chain = Scraprr::StripFilter.new(@chain)
      @chain.run(value).must_equal(nil)
    end
  end
end
