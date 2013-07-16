class Student < ActiveRecord::Base
  
  attr_accessible :school, :graduation_year, :majors, :nationality, :type_user, :most_interested_industry, :resume
  belongs_to :user, :dependent => :destroy
  has_many :company_details
  has_many :testimonials
  has_many :interviews


  NATIONALITIES = %w(Singaporean PR Foreigner)
  SCHOOLS = %w(NTU NUS SIM SUTD SMU SIT Others)
  TYPES = %w(Student Professional)

  has_attached_file :resume, :less_than => 1.megabytes

  validate :correct_content_type, :message => ", Only PDF, EXCEL, WORD or TEXT files are allowed."


  def correct_content_type 
    acceptable_types = ["application/pdf","application/vnd.ms-excel",     
               "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
               "application/msword", 
               "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
               "text/plain"]
    return true unless resume.present?
    acceptable_types.include? resume.content_type.chomp
  end
  #$validates :school, :presence => true, :inclusion => { :in => SCHOOLS}, :allow_blank => true
  #validates :nationality, :inclusion => { :in => NATIONALITIES}, :allow_blank => true
  validates :type_user, :inclusion => { :in => TYPES}
  validates :most_interested_industry, :inclusion => { :in => CompanyDetail::INDUSTRIES}
end