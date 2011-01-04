class Client < ActiveRecord::Base
  has_many :projects, :order => :name, :dependent => :destroy
  belongs_to :contact, :class_name => 'Person'
  
  scope :active, where(:archived => false)

  validates_numericality_of :contact_id
  validates_associated :contact
  
  validates_presence_of :name

  def fullname
    self.name
  end
  
  def work_categories
    # FIXME these can be db items if any client wants other values
    {
      'D' => 'Development', 'M' => 'Maintenance'
    }
  end
  
end
