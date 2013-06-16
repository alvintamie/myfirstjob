class Comment < ActiveRecord::Base
  
  attr_accessible :user, :user_id, :content, :testimonial_id, :testimonial

  belongs_to :user
  belongs_to :testimonial
 
end