class Job < ActiveRecord::Base
  
  attr_accessible :title, :location, :date_posted, :number_of_hires, :employer, :status, :rejected_message
  attr_accessible :deadline, :start_date, :end_date, :responsibility, :requirements, :job_type, :industry, :job_scope, :salary, :employer_id

  belongs_to :employer

  JOB_TYPE = [["All","all"],["Full time","full+time"],["Part time","part+time"],["Contract","contract"],["Internship","internship"],["Temporary","temporary"]]
  JOB_POSITION_LEVEL = [["All","all"],["Fresh Graduates","graduate"],["Manager","manager"],["Senior Executive","senior+executive"],["Junior Executive","junior+executive"]]
  JOB_EDUCATION = [["All","all"],["Diploma","diploma"],["Degree, Bachelor","degree+or+bachelor"],["Masters, MBA","masters+or+mba"],["Doctorate, PHD","doctorate+or+phd"]]
  JOB_INDUSTRY = ["Accounting & Financial Management","Consulting","Aerospace","Engineering & Manufacturing","Banking","Insurance & Financial Services","Investment & Investment Banking","Construction","Civil Engineering","Property & Development","Hospitality","Leisure & Tourism","Infocomms","Energy/Oil & Gas/Utilities","FMCG/Retail","Healthcare & Pharmaceutical","Scientific Research & Development","Legal","Logistics","Transport & SUpply Chain","Public Sector"]
  JOB_SCOPE = %w(Engineering Research Accounting)
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
    if self.end_date.present?
      errors.add :end_date, "Your date format is invalid"  unless check_date_format self.end_date
      errors.add(:start_date, "Start date must be earlier than end date") if start_date.to_i > end_date.to_i
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

end