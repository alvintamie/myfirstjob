class TestimonialsController < ApplicationController

  def new
    @testimonial = Testimonial.new
    @testimonial.contents = Hash.new
    @events = Event.approveds.featureds.order("created_at DESC").limit(10)
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds.order("company_name ASC")
  end

  def create
    @testimonial = Testimonial.new(params[:testimonial])
    @events = Event.approveds.featureds.order("created_at DESC").limit(10)
    @company_detail = @testimonial.company_detail
    @company_details = CompanyDetail.approveds.order("company_name ASC")
    @testimonial.status = "pending"
    @testimonial.anonymous = true
    if @testimonial.save
      flash[:success] = "You have successfully created a company review! Thank you for your submission!"
      redirect_to root_path
    else
      render :new
    end
  end
end