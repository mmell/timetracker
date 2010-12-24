class Activity < ActiveRecord::Base
  belongs_to :task
  belongs_to :person
#  belongs_to :objective, :through => :task
#  belongs_to :project, :through => :objective

  validates_numericality_of :task_id
  validates_numericality_of :person_id
  
  validates_associated :task
  validates_associated :person
  
  before_save :defaults
  
  def defaults
    self.stopped ||= DateTime.now
  end
  
end
