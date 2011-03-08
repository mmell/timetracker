class ProjectPosition < ActiveRecord::Base
  belongs_to :person
  belongs_to :project
  
  validates_associated :person
  validates_associated :project

  validates_numericality_of(:position)
  validates_uniqueness_of( :position, :scope => :person_id )
  
end
