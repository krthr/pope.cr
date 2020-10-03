require "./spec_helper"

NAME = "Wilson"

describe Pope do
  describe "#prop" do
    it "works with hash" do
      data = {
        "name" => NAME,
      }

      result = Pope.prop data, "name"
      result.should eq NAME
    end

    it "works with namedtuple" do
      data = {
        name: NAME,
      }

      result = Pope.prop data, "name"
      result.should eq NAME
    end

    it "throws exception" do
      expect_raises(Pope::MissinPath) do
        Pope.prop({
          "name" => NAME,
        })
      end
    end
  end
end
