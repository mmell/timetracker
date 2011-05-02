require "spec_helper"

describe Project do
  it "fails validation with no name" do
    Project.new.should have(1).error_on(:name)
  end

  it "passes validation with a name" do
    Project.new(:name => "liquid nitrogen").should have(:no).errors_on(:name)
  end
  
  it "archiving project destroys project position" do
    project = Factory.create(:project)
    person = Factory.create(:person)
    project_position = Factory.create(:project_position, :project => project, :person => person, :position => 1)
    project.update_attributes(:archived => true)
    expect { ProjectPosition.find(project_position.id) }.to raise_error(ActiveRecord::RecordNotFound)    
  end
  
  it "has a parent_name" do
    project = Factory.create(:project)
    project.parent_name.should == nil
  end
  
  it "has a parent_name" do
    parent = Factory.create(:project)
    project = Factory.create(:project, :parent => parent)
    project.parent_name.should == parent.name
  end
  
end
