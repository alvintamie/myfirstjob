class Testimonial < ActiveRecord::Base
  extend ModelUtilities 
  attr_accessible :position, :upvotes, :downvotes, :tmp_company_name, :grade, :contents, :anonymous, :company_detail_id, :student_id, :student, :votes

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