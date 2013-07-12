class Testimonial < ActiveRecord::Base
  extend ModelUtilities 
  attr_accessible :position, :upvotes, :downvotes, :tmp_company_name, :grade, :contents, :anonymous, :start_date, :end_date, :company_detail_id, :student_id, :student, :votes

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

  scope :pendings, where(:status => "pending")
  scope :rejecteds, where(:status => "rejected")
  scope :approveds, where(:status => "approved")
  scope :positives, where(:grade => "Positive")
  scope :neutrals, where(:grade => "Neutral")
  scope :negatives, where(:grade => "Negative")


  validates :grade, :presence => true, :inclusion => { :in => GRADES}
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :position, :presence => true

  validate :contents_validation
  validate :date_validation

  def contents_validation
    errors.add :contents, "Your Comment on the company environment can't be empty" if contents["culture"].blank?
    errors.add :contents, "Your Comment on the work-life balance  can't be empty" if contents["work_balance"].blank?
    errors.add :contents, "Your Share with us the overall job/internship experience can't be empty" if contents["work_experience"].blank?

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
    anonymous ? "/anonymous.jpeg" : student.user.profile_image.url(:thumbnail)
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