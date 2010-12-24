class CurrentActivity < ActiveRecord::Base
  belongs_to :task
  belongs_to :person
  
  validates_presence_of :started
  
  validates_numericality_of :task_id
  validates_numericality_of :person_id
  
  validates_associated :task
  validates_associated :person
  
  before_create :stop_user
  
  before_destroy :archive_activity

  def archive_activity
    Activity.create(
      :person_id => self.person_id,
      :task_id => self.task_id,
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
