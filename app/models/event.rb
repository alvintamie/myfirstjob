class Event < ActiveRecord::Base
  
  attr_accessible :content, :title, :image, :status

  STATUS = ["approved", "pending"]

  has_attached_file :image, :styles => {
    :thumbnail => {
      :geometry => "200x200",
    }
  }

  scope :pendings, where(:status => "pending")
  scope :approveds, where(:status => "approved")
  
  def is_approved?
    status == "approved"
  end

  def is_pending?
    status == "pending"
  end

end