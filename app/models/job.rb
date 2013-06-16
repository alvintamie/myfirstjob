class Job < ActiveRecord::Base
  
  attr_accessible :majors, :title, :location, :date_posted, :number_of_hires, :employer, :status, :rejected_message
  attr_accessible :deadline, :start_date, :end_date, :responsibility, :requirements, :job_type, :industry, :job_scope, :salary, :employer_id

  belongs_to :employer

  JOB_TYPE = %w(it accounting)
  JOB_INDUSTRY = %w(it banking)
  JOB_SCOPE = %w(test1 test2 test3)
  JOB_SCOPE = %w(rejected approved pending)


  validates :job_type, :presence => true, :inclusion => { :in => JOB_TYPE}
  validates :industry, :presence => true, :inclusion => { :in => JOB_INDUSTRY}
  validates :job_scope, :presence => true, :inclusion => { :in => JOB_SCOPE}
  validates :status, :presence => true, :inclusion => { :in => STATUS}


  scope :pendings, where(:status => "pending")
  scope :rejecteds, where(:status => "rejected")
  scope :approveds, where(:status => "approved")

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