class Event < ActiveRecord::Base
  
  attr_accessible :content, :title, :image, :status, :author, :label, :label_link, :featured

  STATUS = ["approved", "pending"]

  has_attached_file :image, :styles => {
    :thumbnail => {
      :geometry => "200x200",
    }
  }

  scope :pendings, where(:status => "pending")
  scope :approveds, where(:status => "approved")
  scope :featureds, where(:featured => true)

  validates :title,:presence => true
  validates :author,:presence => true
  validates :label,:presence => true
  validates :label_link,:presence => true
  validates :status, :presence => true, :inclusion => { :in => STATUS}
  
  def is_approved?
    status == "approved"
  end

  def is_pending?
    status == "pending"
  end

end