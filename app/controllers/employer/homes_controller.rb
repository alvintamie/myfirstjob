class Employer::HomesController < ApplicationController
	before_filter :authenticate_employer_user!

	def index
		@jobs = current_user.employer.jobs
		@total_jobs = @jobs.size
	end
end
