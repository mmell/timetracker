require "spec_helper"

describe Project do
  it "fails validation with no name" do
    Project.new.should have(1).error_on(:name)
  end

  it "passes validation with a name" do
    Project.new(:name => "liquid nitrogen").should have(:no).errors_on(:name)
  end

end
