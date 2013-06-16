class Student::HomesController < ApplicationController
	before_filter :authenticate_student_user!

	def index
	end 
end
