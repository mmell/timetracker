class CurrentActivity < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  validates_presence_of :project_id
  validates_presence_of :person_id

# conflicts with existing activity   validates_uniqueness_of :person_id
  
  validates_associated :project
  validates_associated :person
  
  validates_presence_of :started
  
  before_create :stop_user
  
  before_destroy :archive_activity
  before_validation :defaults
  
  def defaults
    if self.new_record? and self.description.blank? and !self.project.activities.empty?
      self.description = self.project.activities.last.description
    end
  end
  
  def archive_activity
    @archive_activity ||= Activity.create( # don't allow duplicates
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
  
  def hours
    "%6.2f" % [ minutes / 60.0 ]
  end

end
