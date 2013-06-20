class Student::HomesController < ApplicationController
	before_filter :authenticate_student_user!

	def index
    	@events = Event.approveds
    	@testimonials = Testimonial.find(:all, :limit => 2, :order => "created_at DESC")
	end 
end
