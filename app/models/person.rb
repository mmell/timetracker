class Person < ActiveRecord::Base
  has_many :activities, :order => "stopped DESC", :dependent => :destroy
  has_one :current_activity, :dependent => :destroy
  has_many :tasks, :through => :activities, :order => "clients.name, projects.name, objectives.name, tasks.name", :include => {:objective => {:project => :client } }
  
  validates_presence_of :name
  validates_presence_of :email
  
end
