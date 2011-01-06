class Project < ActiveRecord::Base
  belongs_to :client
  belongs_to :parent, :class_name => 'Project'
  has_many :projects, :order => :name, :foreign_key => :parent_id, :dependent => :destroy
  has_many :activities, :order => :stopped, :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  
  scope :active, where(:archived => false)

  validates_presence_of :client_id
  validates_associated :client
#  validates_presence_of :parent_id
  validates_associated :parent

  validates_presence_of :name
  
  before_save :defaults
  
  def defaults
    self.url = 'http://' + self.url unless 0 == (self.url =~ /.*\:\/\/.*/) or self.url.blank?
  end
  
  def fullname
    if parent_id
      "#{parent.fullname}::#{self.name}"
    else
      "#{client.name}::#{self.name}"
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
