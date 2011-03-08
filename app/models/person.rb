class Person < ActiveRecord::Base
  has_many :activities, :order => "stopped DESC", :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :projects, :through => :activities, :order => "projects.name"
  has_one :project, :through => :current_activity
  has_many :project_positions, :dependent => :destroy
  
  validates_presence_of :name
  validates_presence_of :email
  
  validates_uniqueness_of :email
  
  def local_time(t) 
    t.in_time_zone(time_zone)
  end
  
  def project_position(project)
    project_positions.each { |e| return e if e.project_id == project.id }
    ProjectPosition.new(:project => project, :position => 0)
  end

  def shift_project_position(project, move_to)
    move_to = move_to.to_i() -1
    list = self.project_positions.dup
    list.delete(project_position(project))
    pp = project_positions.create(:project => project, :position => move_to)
    list.insert(move_to, pp)
    list.each_index { |ix| # the list is in order. The positions need to be updated to match.
      list[ix].update_attribute( :position, ix +1)
    }
  end

end
