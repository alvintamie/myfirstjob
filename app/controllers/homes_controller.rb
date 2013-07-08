class HomesController < ApplicationController

  def index
    @events = Event.approveds.featureds.order("created_at DESC").limit(2)
    @testimonials = Testimonial.find(:all, :limit => 3, :order => "created_at DESC")
    @interviews = Interview.find(:all, :limit => 3, :order => "created_at DESC")
    @featured_company_details = CompanyDetail.featureds
  end 

  def company_hub
    @company_details = CompanyDetail
    @company_details = @company_details.where("lower(company_name) LIKE ?", "%#{params[:search_key].downcase}%") if params[:search_key].present?
    @company_details = @company_details.where(:company_type => params[:company_type]) unless params[:company_type] == "all" || params[:company_type].nil?
    @company_details = @company_details.where(:company_industry => params[:company_industry]) unless params[:company_industry] == "all" || params[:company_industry].nil?
    @company_details = @company_details.approveds.order('company_name ASC').paginate(:page => params[:page], :per_page => 10)
  end

  def career_info

  end

  def about
  end

  def contact

  end

  def faq

  end

  def privacy

  end

  def terms

  end

end