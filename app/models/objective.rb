class Objective < ActiveRecord::Base
  belongs_to :project
  has_many :tasks, :order => "created_at DESC", :dependent => :destroy

  scope :active, where(:archived => false)

  validates_numericality_of :project_id
  validates_associated :project

  before_save :defaults
  
  def defaults
    self.description = self.description.strip
  end
  
  def fullname
    "#{project.fullname}::#{self.name}"
  end
  
  def minutes
    Activity.sum(:minutes, :conditions => "#{self.id}=tasks.objective_id", :include => :task )
  end
  
  def work_category
    'M'
  end
  
end
