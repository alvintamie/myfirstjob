class Student::CompanyDetailsController < ApplicationController
  before_filter :authenticate_student_user!, :only => [:edit, :show, :new, :create, :update]

  def index
    @company_details = current_user.student.company_details
  end

  def new
    @company_detail = CompanyDetail.new
  end

  def create
    @company_detail = CompanyDetail.new(params[:company_detail])
    @company_detail.student = current_user.student
    @company_detail.status = "pending"
    if @company_detail.save
      flash[:success] = "You have successfully create a company detail, thank you for your submission"
      redirect_to student_company_details_path
    else
      render :new
    end
  end

  def edit
    @user = CompanyDetail.find_by_id(params[:id])
  end

  def update
    @company_detail = CompanyDetail.find_by_id(params[:id])
    if @company_detail.update_attributes(params[:company_detail])
      flash[:success] = "You have successfully updated a company detail, thank you for your update"
      redirect_to student_company_details_path    
    else
      render :edit
    end  
  end

  def destroy
    @company_detail = CompanyDetail.find(params[:id])
    if @company_detail.is_approved?
      flash[:error] = "You cant delete an approved company detail"
    else
      @company_detail.destroy
      flash[:success] = "You have successfully delete a company detail"
      redirect_to student_company_details_path
    end
  end
end