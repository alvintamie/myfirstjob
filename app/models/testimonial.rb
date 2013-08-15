class Testimonial < ActiveRecord::Base
  extend ModelUtilities 
  attr_accessible :position, :upvotes, :status, :downvotes, :tmp_company_name, :other, :grade, :contents, :anonymous, :company_detail_id, :student_id, :student, :votes, :experience_level, :still_employer, :last_working_month, :last_working_year
  before_save :check_last_working_date
  #:start_date, :end_date,
  serialize :contents
  serialize :upvotes, Array
  serialize :downvotes, Array

  belongs_to :company_detail
  belongs_to :student
  has_many :comments

  SORT_KEYS = { :asc => %w(position), :default => "id desc"}
  STATUS = ["approved", "rejected", "pending"]
  SEARCH_KEYS = ["position"]
  GRADES = ["Positive", "Neutral", "Negative"]
  EXPERIENCE_LEVEL = ["Intern","Graduate/Junior Level","Mid Level","Senior Level"]
  MONTHS = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"]

  scope :pendings, where(:status => "pending")
  scope :rejecteds, where(:status => "rejected")
  scope :approveds, where(:status => "approved")
  scope :positives, where(:grade => "Positive")
  scope :neutrals, where(:grade => "Neutral")
  scope :negatives, where(:grade => "Negative")


  validates :grade, :presence => true, :inclusion => { :in => GRADES}
  validates :status, :presence => true, :inclusion => { :in => STATUS}
  validates :experience_level, :presence => true, :inclusion => { :in => EXPERIENCE_LEVEL}
  validates :last_working_month, :presence => true, :inclusion => { :in => MONTHS}
  validates :last_working_year, :presence => true, :inclusion => { :in => proc {(1993 .. Time.now.year).to_a}}
  # validates :start_date, :presence => true
  # validates :end_date, :presence => true
  validates :position, :presence => true

  validate :contents_validation
  #validate :date_validation
  validate :company_validation

  def company_validation
    errors.add :other, "You must either specify \"Company Name\" Field or \"Other\" Field if the company is not listed" if company_detail.nil? && other.blank?
  end

  def contents_validation
    errors.add :contents, "The company culture field cannot be empty" if contents["culture"].blank?
    errors.add :contents, "The work-life balance field cannot be empty" if contents["work_balance"].blank?
    errors.add :contents, "Your overall job/internship experience field cannot be empty" if contents["work_experience"].blank?
  end

  def check_last_working_date
    if self.still_employer
      self.last_working_year = Time.now.year
      self.last_working_month = MONTHS[Time.now.month - 1]
    end
  end

  def check_date_format t
    t.strftime('%d/%m/%Y/') rescue return false
    return true
  end

  def date_validation
    errors.add :start_date, "Your date format is invalid" unless check_date_format self.start_date 
    if self.end_date.present?
      errors.add :end_date, "Your date format is invalid"  unless check_date_format self.end_date
      errors.add(:start_date, "must be earlier than end_date") if start_date.to_i > end_date.to_i
    end
  end

  def is_approved?
    status == "approved"
  end

  def is_pending?
    status == "pending"
  end

  def is_rejected?
    status == "rejected"
  end

  def profile_image
    if anonymous || student.user.profile_image.url(:thumbnail).include?("missing.png")
      "/anonymous.jpeg"
    else
      student.user.profile_image.url(:thumbnail)
    end
  end

  def student_name
    anonymous ? "Anonymous" : student.user.first_name
  end

  def user_vote? user
      return [false,false]
      upvoted = upvotes.include? user.id
      downvoted = downvotes.include? user.id
      [upvoted, downvoted]
  end

end