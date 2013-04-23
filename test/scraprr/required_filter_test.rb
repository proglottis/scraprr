require 'test_helper'

describe Scraprr::RequiredFilter do
  describe "#run" do
    before do
      @chain = MiniTest::Mock.new
    end

    it "returns value if value is present" do
      value = 'something'
      @chain.expect(:run, value, [value])
      @chain = Scraprr::RequiredFilter.new(@chain, "name")
      @chain.run(value).must_equal value
    end

    it "raises if value is blank" do
      value = ''
      @chain.expect(:run, value, [value])

      @chain = Scraprr::RequiredFilter.new(@chain, "name")
      proc {
        @chain.run(value)
      }.must_raise(Scraprr::MissingAttributeError)
    end

    it "raises if value is nil" do
      value = nil
      @chain.expect(:run, value, [value])

      @chain = Scraprr::RequiredFilter.new(@chain, "name")
      proc {
        @chain.run(value)
      }.must_raise(Scraprr::MissingAttributeError)
    end
  end
end
