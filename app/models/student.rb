class Student < ActiveRecord::Base
  
  attr_accessible :school, :graduation_year, :majors, :nationality

  belongs_to :user, :dependent => :destroy
  has_many :company_details
  has_many :testimonials
  has_many :interviews

  NATIONALITIES = %w(indonesian singaporean malay)
  SCHOOLS = %w(NTU NUS SIM)

  validates :school, :presence => true, :inclusion => { :in => SCHOOLS}
  validates :nationality, :inclusion => { :in => NATIONALITIES}, :allow_blank => true

end
  