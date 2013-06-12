class CompanyDetailsController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :show, :new, :create, :update]

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



end