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

  describe "#pope" do 
    it "no-ops on strings without template expressions" do
      data = {
        name: NAME,
      }
      input = "this is a test, yay!"   
      
      result = Pope.pope(input, data)
      result.should eq input
    end

    it "evaluates strings that only consist of a template expression" do
      data = {
        name: NAME,
      }

      input = "{{name}}"   
      
      result = Pope.pope(input, data)
      result.should eq NAME
    end

    it "evaluates strings that have a mix of template expressions and non-template-expression constant strings" do
      data = {
        name: NAME,
        age: 42
      }

      input = "My name is {{name}} and I am {{age}} years old"
      
      result = Pope.pope(input, data)
      result.should eq "My name is #{data[:name]} and I am #{data[:age]} years old"
    end

    describe "with filters" do 
      it "applies the upper filter correctly" do 
        data = {
          name: NAME,
        }

        result = Pope.pope("Your name is {{name | upper}}", data)
        result.should eq "Your name is #{NAME.upcase}"
      end

      it "applies the lower filter correctly" do 
        data = {
          name: NAME,
        }

        result = Pope.pope("Your name is {{name | lower}}", data)
        result.should eq "Your name is #{NAME.downcase}"
      end

      it "applies multiple filters in the same expression correctly" do
        data = {
          name: NAME,
        }

        result = Pope.pope("Your name is {{name | lower | upper}}", data)
        result.should eq "Your name is #{NAME.downcase.upcase}"
      end

      it "applies multiple filters in different expressions correctly" do
        data = {
          name: NAME,
          title: "Programmer"
        }

        result = Pope.pope("Your name is {{name | lower}}, and you're a {{title | upper}}", data)
        result.should eq "Your name is #{NAME.downcase}, and you're a #{data[:title].upcase}"
      end

      it "raises an exception when an unrecognized filter is specified" do
        data = {
          name: NAME
        }

        expect_raises(Pope::InvalidFilter, "Invalid filter: 'fakenotrealfilter'") do 
          Pope.pope("Test fake filter: {{name | fakenotrealfilter}}", data)
        end
      end

      it "raises an exception when a filter expression is incorrectly terminated" do
        data = {
          name: NAME
        }

        expect_raises(Pope::InvalidFilter, "Invalid filter: ''") do 
          Pope.pope("Test fake filter: {{name | }}", data)
        end
      end
    end
  end
end
