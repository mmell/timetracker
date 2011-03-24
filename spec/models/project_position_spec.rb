require "spec_helper"

describe ProjectPosition do

  it "new has a position of 0" do
    subject.position.should == 0
  end

  it "re-sorts the persons projects after project_position is gone" do
    parent_project = Factory.create(:project)
    person = Factory.create(:person)
    projects = [Factory.create(:project, :parent => parent_project)]
    Factory.create(:project_position, :project => projects[0], :person => person, :position => 1)
    projects << Factory.create(:project, :parent => parent_project)
    Factory.create(:project_position, :project => projects[1], :person => person, :position => 2)
    projects << Factory.create(:project)
    Factory.create(:project_position, :project => projects[2], :person => person, :position => 3)

    person.project_position(projects[0]).position.should == 1
    person.project_position(projects[1]).position.should == 2
    person.project_position(projects[2]).position.should == 3
    person.project_positions.map { |e| e.position }.should == [1, 2, 3]

    projects[0].update_attributes(:archived => true)

    person = Person.find(person.id)
    person.project_position(projects[0]).new_record?.should be_true
    person.project_position(projects[0]).position.should == 0
    person.project_position(projects[1]).position.should == 1
    person.project_position(projects[2]).position.should == 2
    person.project_positions.map { |e| e.position }.should == [1, 2]

  end

end
