class EventsController < ApplicationController

  def index
    @events = Event.approveds.paginate(:page => params[:page], :per_page => 3)
  end

  def show
    @event = Event.find_by_id(params[:id])
  end



end