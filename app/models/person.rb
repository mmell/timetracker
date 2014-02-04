class Person < ActiveRecord::Base
  has_many :activities, -> { order("stopped DESC") }, :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :projects, -> { order("projects.name") }, :through => :activities
  has_one :project, :through => :current_activity
  has_many :project_positions, -> { order(:position) }, :dependent => :destroy
  has_many :priority_projects, :through => :project_positions, :source => :project

  validates_presence_of :name
  validates_presence_of :email

  validates_uniqueness_of :email

  scope :priority, -> { where(archived: true) }

  ParamAttributes = [ :name, :email, :image_url, :time_zone]

  def local_time(t)
    t.in_time_zone(time_zone)
  end

  def project_position(project)
    project_positions.each { |e| return e if e.project_id == project.id }
    ProjectPosition.new(:person => self, :project => project, :position => 0)
  end

  def shift_project_position(project, move_to)
    pp = project_position(project)
    pp.position = move_to.to_i() -1
    new_project_positions = []
    self.project_positions.each { |e|
      next if e == pp
      new_project_positions << e
    }
    if pp.position < 0 # the submitted move_to was 0 which means delete_me
      pp.destroy if pp.persisted?
    else
      new_project_positions.insert(pp.position, pp)
    end
    update_project_positions( new_project_positions.compact )
  end

  def update_project_positions(list)
    list.each_index { |ix| # the array items are in order. The positions need to be updated to match.
      list[ix].update_column( :position, ix +1)
    }
  end

end
