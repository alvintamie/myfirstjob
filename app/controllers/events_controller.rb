class EventsController < ApplicationController

  def index
    @events = Event.approveds.order("created_at DESC").paginate(:page => params[:page], :per_page => 8)
    @featuredevents = Event.approveds.featureds.order("created_at DESC").limit(10)
  end

  def show
    @event = Event.find_by_id(params[:id])
    @featuredevents = Event.approveds.featureds.order("created_at DESC").limit(10)
  end



end