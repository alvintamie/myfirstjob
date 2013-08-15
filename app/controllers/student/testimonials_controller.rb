class Student::TestimonialsController < ApplicationController
  before_filter :authenticate_student_user!, :only => [:edit, :show, :new, :create, :update]

  def new
    @testimonial = Testimonial.new
    @testimonial.contents = Hash.new
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds
    @events = Event.approveds.featureds.order("created_at DESC").limit(10)
  end

  def create
    @testimonial = Testimonial.new(params[:testimonial])
    @company_detail = @testimonial.company_detail
    @company_details = CompanyDetail.approveds
    @testimonial.status = @testimonial.company_detail.nil? && @testimonial.present? ? "pending" : "approved"
    @testimonial.student = current_user.student
    @events = Event.approveds.featureds.order("created_at DESC").limit(10)
    if @testimonial.save
      flash[:success] = "You have successfully created a company review! Thank you for your submission!"
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
    @upvoted, @downvoted = @testimonial.user_vote? current_user
    @comments = @testimonial.comments
    @comment = Comment.new
    @from_current_student  = @testimonial.student == current_user.student ? true : false
    @events = Event.approveds.featureds.order("created_at DESC").limit(10)
  end

  def edit
    @testimonial = Testimonial.find_by_id(params[:id])
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds
    redirect_to student_homes_path unless @testimonial.student == current_user.student
    @events = Event.approveds.featureds.order("created_at DESC").limit(10)
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

  def upvote
    @testimonial = Testimonial.find(params[:id])
    if @testimonial.upvotes.include? current_user.id
      return render :json => { :status => "error", :message => "user already upvote"}
    end
    if @testimonial.downvotes.include? current_user.id
      @testimonial.downvotes.delete(current_user.id)
      @testimonial.votes += 1
      @testimonial.save
      return render :json => { :status => "success", :message => "neutralize downvoted"}
    end
    @testimonial.upvotes << current_user.id
    @testimonial.votes +=1
    @testimonial.save
    render :json => { :status => "success"}
  end

  def downvote
    @testimonial = Testimonial.find(params[:id])
    @testimonial.downvotes = [] if @testimonial.downvotes.nil?
    if @testimonial.downvotes.include? current_user.id
      return render :json => { :status => "error", :message => "user already downvote"}
    end
    if @testimonial.upvotes.include? current_user.id
      @testimonial.upvotes.delete(current_user.id)
      @testimonial.votes -=1
      @testimonial.save
      return render :json => { :status => "success", :message => "neutralize upvoted"}
    end
    @testimonial.downvotes << current_user.id
    @testimonial.votes -=1
    @testimonial.save
    render :json => { :status => "success"}
  end

end