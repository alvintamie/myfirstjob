class Student < ActiveRecord::Base
  
  attr_accessible :school, :graduation_year, :majors, :nationality

  belongs_to :user, :dependent => :destroy
  has_many :company_details
  has_many :testimonials

  NATIONALITIES = %w(indonesian singaporean malay)


end
  