class Employer < ActiveRecord::Base
  
  attr_accessible :company_name , :company_type, :address

  belongs_to :user, :dependent => :destroy
  has_many :company_details, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  
  TYPES = %w(mnc startup)

  validates :company_type, :presence => true, :inclusion => { :in => TYPES}


end
  