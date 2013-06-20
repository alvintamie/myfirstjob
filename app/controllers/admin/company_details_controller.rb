class Admin::CompanyDetailsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @company_details, @tab = case params[:tab]
    when "approved"
      [CompanyDetail.approveds.order('updated_at DESC').page(params[:page]), "approved"]
    when "rejected"
      [CompanyDetail.rejecteds.order('updated_at DESC').page(params[:page]), "rejected"]
    else
      [CompanyDetail.pendings.order('updated_at DESC').page(params[:page]), "pending"]
    end
  end
  
  def new
    @company_detail = CompanyDetail.new
  end

  def show
    @company_detail = CompanyDetail.find_by_id(params[:id])
    @testimonials = @company_detail.testimonials
  end

  def create
    @company_detail = CompanyDetail.new(params[:company_detail])
    @company_detail.status = "pending"
    if @company_detail.save
      flash[:success] = "You have can approve it in pending section"
      redirect_to admin_company_details_path
    else
      render :new
    end
  end

  def edit
    @company_detail = CompanyDetail.find_by_id(params[:id])
  end

  def update
    @company_detail = CompanyDetail.find_by_id(params[:id])
    if @company_detail.update_attributes(params[:company_detail])
      flash[:success] = "You have successfully updated a company detail"
      redirect_to admin_company_details_path    
    else
      render :edit
    end  
  end

  def destroy
    @company_detail = CompanyDetail.find(params[:id])
    @company_detail.destroy
    flash[:success] = "You have successfully delete a company detail"
    redirect_to admin_company_details_path
  end

  def approve
    @company_detail = CompanyDetail.find(params[:id])
    @company_detail.update_attributes(:status => "approved")
    flash[:success] = "You have successfully approve a company detail"
    redirect_to admin_company_details_path
  end

  def reject
    @company_detail = CompanyDetail.find(params[:id])
    @company_detail.update_attributes(:status => "rejected", :rejected_message => params[:rejected_message])
    SendCompanyDetailRejectionMessageWorker.perform_async(current_user.id, @company_detail.id)
    flash[:success] = "You have successfully reject a company detail"
    redirect_to admin_company_details_path
  end

  def pending
    @company_detail = CompanyDetail.find(params[:id])
    @company_detail.update_attributes(:status => "pending")
    flash[:success] = "You have successfully pending a company detail"
    redirect_to admin_company_details_path
  end

  def featureds
    @company_details = CompanyDetail.featureds
  end
end