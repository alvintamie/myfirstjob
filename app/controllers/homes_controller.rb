class HomesController < ApplicationController

  def index
    @events = Event.approveds.limit(4)
    @featured_company_details = CompanyDetail.featureds
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

  def faq

  end

  def privacy

  end

  def terms

  end

end