require "spec_helper"

describe Project do
  it "fails validation with no name" do
    Project.new.should have(1).error_on(:name)
  end

  it "passes validation with a name" do
    Project.new(:name => "liquid nitrogen").should have(:no).errors_on(:name)
  end

  it "archiving project destroys project position" do
    project = FactoryGirl.create(:project)
    person = FactoryGirl.create(:person)
    project_position = FactoryGirl.create(:project_position, :project => project, :person => person, :position => 1)
    project.update_attributes(:archived => true)
    expect { ProjectPosition.find(project_position.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "has a parent_name" do
    project = FactoryGirl.create(:project)
    project.parent_name.should == "None"
  end

  it "has a parent_name" do
    parent = FactoryGirl.create(:project)
    project = FactoryGirl.create(:project, :parent => parent)
    project.parent_name.should == parent.name
  end

end
