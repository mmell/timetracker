require "spec_helper"

describe CurrentActivity do
  it "fails validation with no associations" do
    subject.should have(1).error_on(:project_id)
    # db default is 0, making this test not trigger      subject.should have(1).error_on(:person_id)
  end

  it "validates with associations" do
    Factory.create(:current_activity, :person => Factory.create(:person), :project => Factory.create(:project)).valid?.should be_true 
  end

  context "a current activity exists" do
    subject { Factory.create(:current_activity, :person => Factory.create(:person), :project => Factory.create(:project)) }

    it "destroys the existing one" do
      Factory.create(:current_activity, :person => subject.person, :project => subject.project)
      expect { CurrentActivity.find(subject.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
