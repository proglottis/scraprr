require 'test_helper'

describe Scraprr::RegexpFilter do
  describe "#run" do
    before do
      @chain = MiniTest::Mock.new
    end

    it "returns value that matches regexp" do
      value = 'Beer1 - 5%, 330ml'
      @chain.expect(:run, value, [value])

      @chain = Scraprr::RegexpFilter.new(@chain, /^(.*) -.*$/)
      @chain.run(value).must_equal('Beer1')
    end

    it "returns nil with no regexp match" do
      value = 'Beer1 - 5%, 330ml'
      @chain.expect(:run, value, [value])

      @chain = Scraprr::RegexpFilter.new(@chain, /^(nothing)$/)
      @chain.run(value).must_equal(nil)
    end
  end
end
