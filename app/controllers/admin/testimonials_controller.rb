class Admin::TestimonialsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @testimonials, @tab = [Testimonial.pendings.order('updated_at DESC').page(params[:page]), "pending"]
  end

  def show
    @testimonial = Testimonial.find_by_id(params[:id])
    if @testimonial.company_detail.nil?
      flash[:error] = "This testimonial don't have company detail assign"
      redirect_to admin_testimonials_path
    end
  end

  def edit
    @testimonial = Testimonial.find_by_id(params[:id])
    @company_detail = @testimonial.company_detail
    @company_details = CompanyDetail.approveds.order("company_name ASC")
  end

  def update
    @testimonial = Testimonial.find_by_id(params[:id])
    @company_detail = @testimonial.company_detail
    @company_details = CompanyDetail.approveds.order("company_name ASC")
    if @testimonial.update_attributes(params[:testimonial])
      flash[:success] = "You have successfully updated a testimonial"
      redirect_to admin_testimonials_path   
    else
      render :edit
    end  
  end

  def destroy
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy
    redirect_to admin_testimonials_path
  end

  def approve
    @testimonial = Testimonial.find(params[:id])
    @testimonial.update_attributes(:status => "approved")
    flash[:success] = "You have successfully approve a testimonial"
    redirect_to admin_testimonials_path
  end
end