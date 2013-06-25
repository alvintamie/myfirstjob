class Job < ActiveRecord::Base
  
  attr_accessible :title, :location, :date_posted, :number_of_hires, :employer, :status, :rejected_message
  attr_accessible :deadline, :start_date, :end_date, :responsibility, :requirements, :job_type, :industry, :job_scope, :salary, :employer_id

  belongs_to :employer

  JOB_TYPE = %w(it accounting)
  JOB_INDUSTRY = %w(it banking)
  JOB_SCOPE = %w(test1 test2 test3)
  STATUS = %w(rejected approved pending)

  scope :pendings, where(:status => "pending")
  scope :rejecteds, where(:status => "rejected")
  scope :approveds, where(:status => "approved")

  validates :job_type, :presence => true, :inclusion => { :in => JOB_TYPE}
  validates :industry, :presence => true, :inclusion => { :in => JOB_INDUSTRY}
  validates :job_scope, :presence => true, :inclusion => { :in => JOB_SCOPE}
  validates :status, :presence => true, :inclusion => { :in => STATUS}

  validate :date_validation

  def check_date_format t
    t.strftime('%d/%m/%Y/') rescue return false
    return true
  end

  def date_validation
    errors.add :date_posted, "Your date format is invalid" unless check_date_format self.date_posted
    errors.add :deadline, "Your date format is invalid" unless check_date_format self.deadline
    errors.add :start_date, "Your date format is invalid" unless check_date_format self.start_date 
    errors.add :end_date, "Your date format is invalid"  unless check_date_format self.end_date
    errors.add(:start_date, "must be earlier than end_date") if start_date.to_i > end_date.to_i
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

end