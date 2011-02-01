class Project < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Project'
  has_many :projects, :order => :name, :foreign_key => :parent_id, :dependent => :destroy
  has_many :activities, :order => :stopped, :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  
  scope :active, where(:archived => false)

#  validates_presence_of :parent_id
  validates_associated :parent

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :parent_id # FIXME add scope of person? but there's no person owner
  
  before_save :defaults
  
  def defaults
    self.url = 'http://' + self.url unless 0 == (self.url =~ /.*\:\/\/.*/) or self.url.blank?
  end
  
  def work_categories
    # FIXME these can be db items if any projects wants other values
    {
      'D' => 'Development', 'M' => 'Maintenance'
    }
  end

  def work_category
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
        
  def shift_to_do_position(moving_to_do, move_to)
    list = self.to_dos.dup
    list.delete(moving_to_do)
    list.insert(move_to.to_i() -1, moving_to_do)
    list.each_index { |ix|
      list[ix].update_attribute( :position, ix +1)
    }
  end
end
