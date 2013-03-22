class Person < ActiveRecord::Base
  has_many :activities, :order => "stopped DESC", :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :projects, :through => :activities, :order => "projects.name"
  has_one :project, :through => :current_activity
  has_many :project_positions, :dependent => :destroy
  has_many :priority_projects, :through => :project_positions, :source => :project
  
  validates_presence_of :name
  validates_presence_of :email
  
  validates_uniqueness_of :email
  
  scope :priority, where(:archived => true)

  def local_time(t) 
    t.in_time_zone(time_zone)
  end
  
  def project_position(project)
    project_positions.each { |e| return e if e.project_id == project.id }
    ProjectPosition.new(:person => self, :project => project, :position => 0)
  end

  def shift_project_position(project, move_to)
    list_position = move_to.to_i() -1
    list = self.project_positions.dup
    pp = project_position(project)
    list.delete(pp) if pp.position > 0

    if list_position < 0 # the submitted move_to was 0
      pp.destroy if pp.position > 0
    else
      list.insert(list_position, pp)
    end
    # not sure compact is necessary except in the tests
    update_project_positions( list.compact )
  end
  
  def update_project_positions(list)
    list.each_index { |ix| # the array items are in order. The positions need to be updated to match.
      list[ix].update_column( :position, ix +1)
    }
  end

end
