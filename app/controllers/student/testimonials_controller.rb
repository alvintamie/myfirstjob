class Student::TestimonialsController < ApplicationController
  before_filter :authenticate_student_user!, :only => [:edit, :show, :new, :create, :update]

  def new
    @testimonial = Testimonial.new
    @testimonial.contents = Hash.new
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds
  end

  def create
    @testimonial = Testimonial.new(params[:testimonial])
    @company_detail = @testimonial.company_detail
    @company_details = CompanyDetail.approveds
    @testimonial.status = "approved"
    @testimonial.student = current_user.student
    if @testimonial.save
      flash[:success] = "You have successfully create a company detail, thank you for your submission"
      if @testimonial.company_detail.nil?
        redirect_to student_homes_path
      else
        redirect_to student_testimonial_path(@testimonial)
      end
    else
      render :new
    end
  end

  def show
    @testimonial = Testimonial.find(params[:id])
    @comments = @testimonial.comments
    @comment = Comment.new
    @from_current_student  = @testimonial.student == current_user.student ? true : false
  end

  def edit
    @testimonial = Testimonial.find_by_id(params[:id])
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds
    redirect_to student_homes_path unless @testimonial.student == current_user.student
  end

  def update
    @testimonial = Testimonial.find_by_id(params[:id])
    @company_detail = @testimonial.company_detail
    @company_details = CompanyDetail.approveds
    if @testimonial.update_attributes(params[:testimonial])
      flash[:success] = "You have successfully updated your testimonial, thank you for your update"
      redirect_to student_testimonial_path(@testimonial)   
    else
      render :edit
    end  
  end

  def destroy
    @testimonial = Testimonial.find(params[:id])
    @company_detail = @testimonial.company_detail
    @testimonial.destroy
    flash[:success] = "You have successfully delete a testimonial"
    redirect_to company_detail_path(@company_detail)
  end

  def comment
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @testimonial = @comment.testimonial
    if @comment.save
      flash[:success] = "You have successfully create a comment for this testimonial"
      redirect_to student_testimonial_path(@testimonial)
    else
      render :show
    end
  end

end