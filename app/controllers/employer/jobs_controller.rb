class Employer::JobsController < ApplicationController
  before_filter :authenticate_employer_user!

  def index
    @jobs = current_user.employer.jobs
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(params[:job])
    @job.employer = current_user.employer
    @job.status = "pending"
    if @job.save
      flash[:success] = "You have successfully create a job detail, thank you for your submission"
      redirect_to employer_jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find_by_id(params[:id])
  end

  def update
    @job = Job.find_by_id(params[:id])
    if @job.update_attributes(params[:job])
      flash[:success] = "You have successfully updated a job detail, thank you for your update"
      redirect_to employer_jobs_path   
    else
      render :edit
    end  
  end

  def destroy
    @job = Job.find(params[:id])
    if @job.is_approved?
      flash[:error] = "You cant delete an approved job detail"
    else
      @job.destroy
      flash[:success] = "You have successfully delete a job detail"
      redirect_to employer_jobs_path
    end
  end



end