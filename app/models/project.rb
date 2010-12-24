class Project < ActiveRecord::Base
  belongs_to :client
  has_many :objectives, :order => "created_at DESC", :dependent => :destroy
  has_many :tasks, :through => :objectives, :order => "created_at DESC"
#  has_many :activities, :through => :tasks, :order => "created_at DESC"
  
  scope :active, where(:archived => false)

  validates_numericality_of :client_id
  validates_associated :client

  validates_presence_of :name
  
  def fullname
    "#{client.name}::#{self.name}"
  end
  
end
