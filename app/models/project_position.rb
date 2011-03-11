class ProjectPosition < ActiveRecord::Base
  belongs_to :person
  belongs_to :project
  
  validates_associated :person
  validates_associated :project

  validates_numericality_of(:position, :greater_than => 0)
  validates_uniqueness_of( :position, :scope => :person_id )
  
  after_destroy :person_update_project_positions
  
  def person_update_project_positions
    person.update_project_positions( person.project_positions(true) )
  end
  
end
