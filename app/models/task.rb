class Task < ActiveRecord::Base
  belongs_to :objective
  has_many :activities, :order => :stopped, :dependent => :destroy
  has_one :current_activity, :dependent => :destroy

  scope :active, where(:archived => false)
  
  validates_numericality_of :objective_id
  validates_associated :objective
  
  def fullname
    "#{self.objective.fullname}::#{self.name}"
  end
  
  def minutes
    @minutes = Activity.sum(:minutes, :conditions => "#{self.id}=task_id" )
  end
  
  def hours
    @hours = minutes / 60.0
  end
  
end
