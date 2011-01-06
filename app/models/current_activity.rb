class CurrentActivity < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  validates_presence_of :project
  validates_presence_of :person_id
  
  validates_associated :project
  validates_associated :person
  
  validates_presence_of :started
  
  before_create :stop_user
  
  before_destroy :archive_activity

  def archive_activity
    Activity.create(
      :person_id => self.person_id,
      :project_id => self.project_id,
      :description => self.description,
      :minutes => self.minutes
    )
  end
  
  def minutes
    (DateTime.now.to_i - self.started.to_i) / 60 
  end
  
  def stop_user
    CurrentActivity.destroy_all(:person_id => self.person_id )
  end
  
end
