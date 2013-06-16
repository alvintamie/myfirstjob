class User < ActiveRecord::Base
  
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :student_attributes, :employer_attributes, :profile_image
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :student_attributes, :employer_attributes, :profile_image, :role, :locked, :activated, :as => :admin

  has_secure_password

  ROLES = %w(admin student alumni employer)
  
  before_create :add_random_password_recoverable
  before_create { generate_token(:auth_token) }
  before_validation(:on => :create)  { |user| user.email = email.downcase rescue nil }

  has_one :student, :dependent => :destroy
  has_one :employer, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_attached_file :profile_image, :styles => {
    :thumbnail => {
      :geometry => "80x80",
    }
  }

  accepts_nested_attributes_for :student
  accepts_nested_attributes_for :employer

  validates :email,:presence => true, :uniqueness => true, :format => { :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i }
  validates :password, :length => { :minimum => 6 }, :allow_blank => true
  validates :role, :presence => true, :inclusion => { :in => ROLES}

  def is_? r
    self.role == r.to_s
  end

  def is_admin?
    self.role == "admin"
  end

  def is_student?
    self.role == "student"
  end

  def is_alumni?
    self.role == "alumni"
  end

  def is_employer?
    self.role == "employer"
  end



private  

  def generate_token(column)  
    begin  
      self[column] = SecureRandom.urlsafe_base64  
    end while User.exists?(column => self[column])  
  end 

  def add_random_password_recoverable
    self.password_recoverable = SecureRandom.uuid.gsub("-", "")
  end

end