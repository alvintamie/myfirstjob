class EventsController < ApplicationController

  def index
    @events = Event.approveds.order("created_at DESC").paginate(:page => params[:page], :per_page => 8)
  end

  def show
    @event = Event.find_by_id(params[:id])
  end



end