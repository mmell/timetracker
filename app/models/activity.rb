class Activity < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  validates_presence_of :project
  validates_presence_of :person_id
  
  validates_associated :project
  validates_associated :person
    
  before_save :defaults
  
  def defaults
    self.stopped ||= DateTime.now.utc
    self.description = self.description.strip
  end
  
  def local_stop_time
    person.local_time(stopped)
  end
  
end
