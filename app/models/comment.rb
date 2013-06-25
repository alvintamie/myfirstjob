class Comment < ActiveRecord::Base
  
  attr_accessible :user, :user_id, :content, :testimonial_id, :testimonial, :interview_id, :interview_id, :interview

  belongs_to :user
  belongs_to :testimonial
  belongs_to :interview
 
end