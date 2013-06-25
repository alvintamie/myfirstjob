class Student::InterviewsController < ApplicationController
  before_filter :authenticate_student_user!, :only => [:edit, :show, :new, :create, :update]

  def new
    @interview = Interview.new
    @interview.contents = Hash.new
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds
  end

  def create
    @interview = Interview.new(params[:interview])
    @company_detail = @interview.company_detail
    @company_details = CompanyDetail.approveds
    @interview.status = "approved"
    @interview.student = current_user.student
    if @interview.save
      flash[:success] = "You have successfully create an interview, thank you for your submission"
      if @interview.company_detail.nil?
        redirect_to student_homes_path
      else
        redirect_to student_interview_path(@interview)
      end
    else
      render :new
    end
  end

  def show
    @interview = Interview.find(params[:id])
    @upvoted, @downvoted = @interview.user_vote? current_user
    @comments = @interview.comments
    @comment = Comment.new
    @from_current_student = @interview.student == current_user.student ? true : false
  end

  def edit
    @interview = Interview.find_by_id(params[:id])
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds
    redirect_to student_homes_path unless @interview.student == current_user.student
  end

  def update
    @interview = Interview.find_by_id(params[:id])
    @company_detail = @interview.company_detail
    @company_details = CompanyDetail.approveds
    if @interview.update_attributes(params[:interview])
      flash[:success] = "You have successfully updated your interview, thank you for your update"
      redirect_to student_interview_path(@interview)   
    else
      render :edit
    end  
  end

  def destroy
    @interview = Interview.find(params[:id])
    @company_detail = @interview.company_detail
    @interview.destroy
    flash[:success] = "You have successfully delete a interview"
    redirect_to company_detail_path(@company_detail)
  end

  def comment
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @interview = @comment.interview
    if @comment.save
      flash[:success] = "You have successfully create a comment for this interview"
      redirect_to student_interview_path(@interview)
    else
      render :show
    end
  end

  def upvote
    @interview = Interview.find(params[:id])
    if @interview.upvotes.include? current_user.id
      return render :json => { :status => "error", :message => "user already upvote"}
    end
    if @interview.downvotes.include? current_user.id
      @interview.downvotes.delete(current_user.id)
      @interview.votes += 1
      @interview.save
      return render :json => { :status => "success", :message => "neutralize downvoted"}
    end
    @interview.upvotes << current_user.id
    @interview.votes +=1
    @interview.save
    render :json => { :status => "success"}
  end

  def downvote
    @interview = Interview.find(params[:id])
    @interview.downvotes = [] if @interview.downvotes.nil?
    if @interview.downvotes.include? current_user.id
      return render :json => { :status => "error", :message => "user already downvote"}
    end
    if @interview.upvotes.include? current_user.id
      @interview.upvotes.delete(current_user.id)
      @interview.votes -=1
      @interview.save
      return render :json => { :status => "success", :message => "neutralize upvoted"}
    end
    @interview.downvotes << current_user.id
    @interview.votes -=1
    @interview.save
    render :json => { :status => "success"}
  end

end