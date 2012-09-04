require "spec_helper"

describe CurrentActivity do
  it "fails validation with no associations" do
    subject.should have(1).error_on(:project_id)
    # db default is 0, making this test not trigger      subject.should have(1).error_on(:person_id)
  end

  it "validates with associations" do
    FactoryGirl.create(:current_activity, :person => FactoryGirl.create(:person), :project => FactoryGirl.create(:project)).valid?.should be_true 
  end

  context "a current activity exists" do
    subject { FactoryGirl.create(:current_activity, :person => FactoryGirl.create(:person), :project => FactoryGirl.create(:project)) }

    it "destroys the existing one" do
      FactoryGirl.create(:current_activity, :person => subject.person, :project => subject.project)
      expect { CurrentActivity.find(subject.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
