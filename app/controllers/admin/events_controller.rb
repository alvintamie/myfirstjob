class Admin::EventsController < ApplicationController
  before_filter :authenticate_admin_user!

  def index
    @events, @tab = case params[:tab]
    when "approved"
      [Event.approveds.order('updated_at DESC').page(params[:page]), "approved"]
    else
      [Event.pendings.order('updated_at DESC').page(params[:page]), "pending"]
    end
  end
  
  def new
    @event = Event.new
  end

  def show
    @event = Event.find_by_id(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:success] = "You have create an event"
      redirect_to admin_events_path
    else
      render :new
    end
  end

  def edit
    @event = Event.find_by_id(params[:id])
  end

  def update
    @event = Event.find_by_id(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = "You have successfully updated a event"
      redirect_to admin_events_path    
    else
      render :edit
    end  
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:success] = "You have successfully delete a event"
    redirect_to admin_events_path
  end



end