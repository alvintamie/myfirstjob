class CompanyDetail < ActiveRecord::Base
  
  attr_accessible :company_name , :company_type, :address, :number_of_employees, :telephone, :fax, :contact_email, :about, :award, :opportunities, :employer

  belongs_to :employer

  TYPES = ["accounting", "it"]
  STATUS = ["approved", "rejected", "pending"]
  NUMBER_OF_EMPLOYEES = ["1-50", "51-100", "100-1000", "> 1000"]

	
  has_attached_file :image
  
  validates :company_type, :presence => true, :inclusion => { :in => TYPES}
  validates :status, :presence => true, :inclusion => { :in => STATUS}
  validates :number_of_employees, :presence => true, :inclusion => { :in => NUMBER_OF_EMPLOYEES}


end