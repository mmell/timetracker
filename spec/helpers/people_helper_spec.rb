require "spec_helper"

describe PeopleHelper do
  
  describe "#project_position_options(ct, ix)" do
    it "creates two options" do
      result = helper.project_position_options(0, 0)

      result.should include("<option value='0'>&mdash;</option>")
      result.should include("<option value='1'>1</option>")
      result.should_not include("<option value='2'>2</option>")
    end

    it "creates three options" do
      result = helper.project_position_options(1, 0)
      result.should include("<option value='2'>2</option>")
      result.should_not include("<option value='3'>3</option>")
    end

    it "creates four options" do
      result = helper.project_position_options(2, 0)
      result.should include("<option value='3'>3</option>")
      result.should_not include("<option value='4'>4</option>")
    end

    it "creates selects the third" do
      result = helper.project_position_options(3, 3)
      result.should include("<option value='3' selected='selected'>3</option>")
    end

  end

end
