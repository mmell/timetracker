class Person < ActiveRecord::Base
  has_many :activities, :order => "stopped DESC", :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :projects, :through => :activities, :order => "clients.name, projects.name", :include => :client
  
  validates_presence_of :name
  validates_presence_of :email
  
  def local_time(t) 
    t.in_time_zone(time_zone)
  end
  

end
