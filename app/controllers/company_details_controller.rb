class CompanyDetailsController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :new, :create, :update]

  def new
    @company_detail = CompanyDetail.new
  end

  def create
    @company_detail = CompanyDetail.new(params[:user])
    @company_detail.status = "pending"
    if @company_detail.save
      user_root!
    else
      render :new
    end
  end

  def edit
    @user = current_user
    @company_detail = CompanyDetail.find_by_id(params[:id])
  end

  def update
    @company_detail = CompanyDetail.find_by_id(params[:id])
    if @company_detail.update_attributes(params[:user])
      flash[:success] = "You have successfully updated a company detail, thank you for your submission"
      user_root!
    else
      render :edit
    end  
  end

  def show
    @company_detail = CompanyDetail.find_by_id(params[:id])
    @testimonials = @company_detail.testimonials.paginate(:page => params[:page], :per_page => 3)
    @interviews = @company_detail.interviews.paginate(:page => params[:page], :per_page => 3)
    @tab = params[:tab].nil? ? "testimonial" : params[:tab]
    @most_popular_testimonial = @company_detail.testimonials.order("votes DESC").first
  end

  def industry
    @company_details = CompanyDetail.where(:company_industry => params[:category]).order("company_name ASC")
    @industry = params[:category]
  end


end