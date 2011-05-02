require "spec_helper"

describe Person do

  def confirm_project_position()
    person.project_position(project1).position.should == 1
  end
  
  it "fails validation with no name" do
    Person.new.should have(1).error_on(:name)
  end

  it "passes validation with a name and email" do
    Person.new(:name => "liquid nitrogen", :email => Factory.next(:email)).valid?.should be_true
  end

  it "builds a new ProjectPosition" do
    project = Project.new
    Person.new.project_position(project).position.should == 0
  end
  
  it "returns a time" do
    subject.local_time(Time.now.utc).should be_a(Time) 
  end

  context "confirm project position" do
    subject { Factory.create(:person) }
    
    it "finds the existing ProjectPosition" do
      project = Factory.create(:project)
      project_position = Factory.create(:project_position, :project => project, :person => subject, :position => 1)
      subject.project_position(project).position.should == 1
    end

    it "sequences positions" do
      project = Factory.create(:project)
      project_position = Factory.create(:project_position, :project => project, :person => subject, :position => 12)
      subject.shift_project_position(project, 3)
      subject.project_position(project).position.should == 1
    end

    it "finds the existing ProjectPosition when there are three" do
      project0 = Factory.create(:project)
      project = nil # define outside the loop
      3.times do |ix|
        project = Factory.create(:project)
        Factory.create(:project_position, :project => project, :person => subject, :position => ix +1)
      end
      subject.project_position(project).position.should == 3
      subject.project_position(project0).position.should == 0
    end

    it "resorts three projects" do
      parent_project = Factory.create(:project)
      projects = [Factory.create(:project, :parent => parent_project)]
      Factory.create(:project_position, :project => projects[0], :person => subject, :position => 1)
      projects << Factory.create(:project, :parent => parent_project)
      Factory.create(:project_position, :project => projects[1], :person => subject, :position => 2)
      projects << Factory.create(:project)
      Factory.create(:project_position, :project => projects[2], :person => subject, :position => 3)
      
      projects.map { |e| subject.project_position(e).position }.should == [1, 2, 3]

      subject.shift_project_position(projects[0], 3)
      projects.map { |e| subject.project_position(e).position }.should == [3, 1, 2]

      subject.shift_project_position(projects[0], 2)
      projects.map { |e| subject.project_position(e).position }.should == [2, 1, 3]

      subject.shift_project_position(projects[0], 3)
      projects.map { |e| subject.project_position(e).position }.should == [3, 1, 2]

      subject.shift_project_position(projects[0], 1)
      projects.map { |e| subject.project_position(e).position }.should == [1, 2, 3]

      subject.shift_project_position(projects[0], 2)
      projects.map { |e| subject.project_position(e).position }.should == [2, 1, 3]

      subject.shift_project_position(projects[1], 2)
      projects.map { |e| subject.project_position(e).position }.should == [1, 2, 3]

      subject.shift_project_position(projects[1], 2)
      projects.map { |e| subject.project_position(e).position }.should == [1, 2, 3]

      subject.shift_project_position(projects[2], 2)
      projects.map { |e| subject.project_position(e).position }.should == [1, 3, 2]

    end

  end
end
