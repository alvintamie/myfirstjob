class Student < ActiveRecord::Base
  
  attr_accessible :school, :graduation_year

  belongs_to :user, :dependent => :destroy


end
  