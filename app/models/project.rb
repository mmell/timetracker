class Project < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Project'
  has_many :projects, :order => :name, :foreign_key => :parent_id, :dependent => :destroy
  has_many :activities, :order => :stopped, :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :project_positions, :dependent => :destroy
  
#  validates_presence_of :parent_id
  validates_associated :parent
  validate :parent_not_self
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :parent_id, :allow_nil => true # FIXME add scope of person? but there's no person owner
  
  before_save :defaults
  after_save :check_archived
  
  scope :root, where(:parent_id => nil).order(:name)
  scope :active, where(:archived => false)
  scope :archived, where(:archived => true)

  def parent_not_self 
    errors.add(:parent_id, :message => "Parent can't be self") if !new_record? and self.parent_id == self.id
  end
  
  def defaults
    self.url = 'http://' + self.url unless 0 == (self.url =~ /.*\:\/\/.*/) or self.url.blank?
  end

  def check_archived
    if archived?
      project_positions.clear
    end
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
      "#{parent.fullname}::#{self.name}"
    else
      "#{self.name}"
    end
  end
  
  def report_name
    name.gsub(/[^a-zA-Z0-9\._]+/, '_')
  end

  def minutes
    @minutes ||= Activity.sum(:minutes, :conditions => "project_id=#{self.id}" )
  end
  
  def hours
    @hours ||= minutes / 60.0
    "%6.2f" % [ @hours ]
  end
        
end
