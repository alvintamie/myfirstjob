class HomesController < ApplicationController

  def index
    @events = Event.approveds
  end 

  def company_hub
    @company_details = CompanyDetail.search_and_sort(params).approveds.page(params[:page])
  end

  def career_info

  end

  def about

  end

  def contact

  end

end