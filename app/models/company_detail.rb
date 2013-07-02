class CompanyDetail < ActiveRecord::Base
  extend ModelUtilities 
  attr_accessible :company_name , :company_type, :company_industry, :featured, :featured_position, :address, :number_of_employees, :telephone, :fax, :contact_email, :about, :award, :opportunities, :employer, :image, :status, :rejected_message

  belongs_to :employer
  belongs_to :student
  has_many :testimonials
  has_many :interviews

  SORT_KEYS = { :asc => %w(company_name, company_type, company_industry), :default => "id desc"}
  TYPES = ["Multi-national Company", "Small Medium Enterprise","Start-up","Government Agency","Government-Linked Companies"]
  INDUSTRIES = ["Accounting & Financial Management","Aerospace","Banking","Civil Engineering","Construction","Consulting","Energy/Oil & Gas/Utilities","Engineering & Manufacturing","FMCG/Retail","Healthcare & Pharmaceutical","Hospitality","Infocomms","Insurance & Financial Services","Investment & Investment Banking","Legal","Leisure & Tourism","Logistics","Property & Development","Public Sector","Scientific Research & Development","Transport & Supply Chain"]
  STATUS = ["approved", "rejected", "pending"]
  NUMBER_OF_EMPLOYEES = ["1-50", "51-100", "100-1000", "> 1000"]
  SEARCH_KEYS = ["company_name", "company_type", "company_industry"]

  scope :featureds, where(:featured => true).order('featured_position ASC')
  scope :pendings, where(:status => "pending")
  scope :rejecteds, where(:status => "rejected")
  scope :approveds, where(:status => "approved")

  has_attached_file :image, :styles => {
    :thumbnail => {
      :geometry => "80x80",
    }
  }
  
  validates :company_type, :presence => true, :inclusion => { :in => TYPES}
  validates :status, :presence => true, :inclusion => { :in => STATUS}
  validates :number_of_employees, :presence => true, :inclusion => { :in => NUMBER_OF_EMPLOYEES}

  def is_approved?
    status == "approved"
  end

  def is_pending?
    status == "pending"
  end

  def is_rejected?
    status == "rejected"
  end

end