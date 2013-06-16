class Employer::HomesController < ApplicationController
	before_filter :authenticate_employer_user!

	def index

	end
end
