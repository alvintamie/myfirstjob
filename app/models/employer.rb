class Employer < ActiveRecord::Base
  
  attr_accessible :company_name , :company_type, :address

  belongs_to :user, :dependent => :destroy
  has_one :company_detail

  TYPES = %w(mnc startup)

  validates :company_type, :presence => true, :inclusion => { :in => TYPES}

end
  