class Project < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Project'
  has_many :projects, -> { order(:name) }, :foreign_key => :parent_id, :dependent => :destroy
  has_many :activities, -> { order(:stopped) }, :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :project_positions, :dependent => :destroy

#  validates_presence_of :parent_id
  validates_associated :parent
  validate :parent_not_self

  validates_presence_of :name
  validates_uniqueness_of :name, conditions: -> { where(archived: false) }, :scope => :parent_id, :allow_nil => true # FIXME add scope of person? but there's no person owner

  after_initialize :defaults
  after_save :check_archived

  scope :root, -> { where(:parent_id => nil).order(:name) }
  scope :active, -> { where(:archived => false).order(:name) }
  scope :archived, -> { where(:archived => true).order(:name) }

  ParamAttributes = [ :name, :url, :archived, :description, :parent_id ]

  def parent_not_self
    errors.add(:parent_id, :message => "Parent can't be self") if !new_record? and self.parent_id == self.id
  end

  def defaults
    self.url = 'http://' + self.url unless 0 == (self.url =~ /.*\:\/\/.*/) or self.url.blank?
  end

  def check_archived
    if archived?
      project_positions.clear
      projects.each { |e| e.archive }
    else
      parent.unarchive if parent
    end
  end

  def unarchive
    update_attributes(archived: false)
  end

  def archive
    update_attributes(archived: true)
  end

  def work_categories
    # FIXME these can be db items if any projects wants other values
    {
      'D' => 'Development', 'M' => 'Maintenance'
    }
  end

  def work_category
    # FIXME: provide UI and column to allow user to choose
    'M'
  end

  def fullname
    if parent_id
      "#{parent.fullname}::#{self.name}" # recurse
    else
      "#{self.name}"
    end
  end

  def report_name
    name.gsub(/[^a-zA-Z0-9\._]+/, '_')
  end

  def minutes
    @minutes ||= self.activities.sum(:minutes)
  end

  def hours
    @hours ||= minutes / 60.0
    "%6.2f" % [ @hours ]
  end

  def self.fullname_sort(arr)
    arr.sort { |a, b| a.fullname <=> b.fullname }
  end

  def parent_name
    parent_id ? parent.fullname : 'None'
  end

  def ordered_sub_projects(project = self)
    @ordered_sub_projects ||= [self]
    project.projects.each { |e|
      @ordered_sub_projects << e
      ordered_sub_projects(e)
    }
    Project.fullname_sort(@ordered_sub_projects)
  end

end
