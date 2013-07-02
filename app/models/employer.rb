class Employer < ActiveRecord::Base
  
  attr_accessible :company_name , :company_type, :address

  belongs_to :user, :dependent => :destroy
  has_many :company_details, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  
  TYPES = ["Multi-national Company", "Small Medium Enterprise","Start-up","Government Agency","Government-Linked Companies"]

  validates :company_type, :presence => true, :inclusion => { :in => TYPES}


end
  