class Person < ActiveRecord::Base
  has_many :activities, :order => "stopped DESC", :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :projects, :through => :activities, :order => "projects.name"
  has_one :project, :through => :current_activity
  
  validates_presence_of :name
  validates_presence_of :email
  
  validates_uniqueness_of :email
  
  def local_time(t) 
    t.in_time_zone(time_zone)
  end
  

end
