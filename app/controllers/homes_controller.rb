class HomesController < ApplicationController

  def index
    @events = Event.approveds.limit(4)
    @featured_company_details = CompanyDetail.featureds
  end 

  def company_hub
    @company_details = CompanyDetail.search_and_sort(params).approveds.paginate(:page => params[:page], :per_page => 10)
  end

  def career_info

  end

  def about
  end

  def contact

  end

  def faq

  end

  def privacy

  end

  def terms

  end

end