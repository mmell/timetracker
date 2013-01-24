require 'activity_time'

class Activity < ActiveRecord::Base
  include ActivityTime

  belongs_to :project
  belongs_to :person
  
  validates_presence_of :project
  validates_presence_of :person_id
  
  validates_associated :project
  validates_associated :person
    
  after_initialize :defaults
  
  def defaults
    self.stopped ||= now
    self.description = self.description.strip
  end
  
  def local_stop_time
    person.local_time(stopped)
  end
  
  def hours
    "%6.2f" % [ minutes / 60.0 ]
  end

end
