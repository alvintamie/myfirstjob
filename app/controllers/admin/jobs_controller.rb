class Admin::JobsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @jobs, @tab = case params[:tab]
    when "approved"
      [Job.approveds.order('updated_at DESC').page(params[:page]), "approved"]
    when "rejected"
      [Job.rejecteds.order('updated_at DESC').page(params[:page]), "rejected"]
    else
      [Job.pendings.order('updated_at DESC').page(params[:page]), "pending"]
    end
  end

  def new
    @job = Job.new
  end

  def show
    @job = Job.find_by_id(params[:id])
  end

  def create
    @job = Job.new(params[:job])
    @job.status = "pending"
    if @job.save
      flash[:success] = "You have sucessfully create a job"
      redirect_to admin_jobs_path
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
      redirect_to admin_jobs_path   
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
      redirect_to admin_jobs_path
    end
  end

  def approve
    @job = Job.find(params[:id])
    @job.update_attributes(:status => "approved")
    flash[:success] = "You have successfully approve a job detail"
    redirect_to admin_jobs_path
  end

  def reject
    @job = Job.find(params[:id])
    @job.update_attributes(:status => "rejected", :rejected_message => params[:rejected_message])
    SendJobRejectionMessageWorker.perform_async(current_user.id, @job.id)
    flash[:success] = "You have successfully reject a job"
    redirect_to admin_jobs_path
  end

  def pending
    @company_detail = Job.find(params[:id])
    @company_detail.update_attributes(:status => "pending")
    flash[:success] = "You have successfully pending a job"
    redirect_to admin_jobs_path
  end
end