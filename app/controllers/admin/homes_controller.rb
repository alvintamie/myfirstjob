class Admin::HomesController < ApplicationController
	before_filter :authenticate_admin_user!

	def index
		@events = Event.approveds.featureds.order("created_at DESC").limit(10)
    	@testimonials = Testimonial.find(:all, :limit => 8, :conditions => { :status => "approved"},:order => "created_at DESC")
    	@interviews = Interview.find(:all, :limit => 3, :order => "created_at DESC")
    	@featured_company_details = CompanyDetail.featureds
	end
end
