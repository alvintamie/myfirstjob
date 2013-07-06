class Interview < ActiveRecord::Base
  extend ModelUtilities 
  attr_accessible :position, :upvotes, :downvotes, :tmp_company_name, :interview_date, :offer_status, :contents, :anonymous, :company_detail_id, :student_id, :student, :votes

  serialize :contents
  serialize :upvotes, Array
  serialize :downvotes, Array

  belongs_to :company_detail
  belongs_to :student
  has_many :comments

  SORT_KEYS = { :asc => %w(position), :default => "id desc"}
  STATUS = ["approved", "rejected", "pending"]
  SEARCH_KEYS = ["position"]
  OFFER_STATUS = ["Yes", "Yes, Did not accept", "Nope"]

  scope :pendings, where(:status => "pending")
  scope :rejecteds, where(:status => "rejected")
  scope :approveds, where(:status => "approved")

  validates :offer_status, :presence => true, :inclusion => { :in => OFFER_STATUS}
  validates :status, :presence => true, :inclusion => { :in => STATUS}


  validate :date_validation

  def check_date_format t
    t.strftime('%d/%m/%Y/') rescue return false
    return true
  end

  def date_validation
    errors.add :interview_date, "Your date format is invalid" unless check_date_format self.interview_date 
    #errors.add :start_date, "Your date format is invalid" unless check_date_format self.start_date 
    #errors.add :end_date, "Your date format is invalid"  unless check_date_format self.end_date
    #errors.add(:start_date, "must be earlier than end_date") if start_date.to_i > end_date.to_i
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
    anonymous ? "Anon" : student.user.first_name
  end

  def user_vote? user
      upvoted = upvotes.include? user.id
      downvoted = downvotes.include? user.id
      [upvoted, downvoted]
  end

end