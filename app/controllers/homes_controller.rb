class HomesController < ApplicationController
  require 'net/http'

  def index
    @events = Event.approveds.featureds.order("created_at DESC").limit(2)
    @testimonials = Testimonial.find(:all, :limit => 6, :order => "created_at DESC")
    @interviews = Interview.find(:all, :limit => 3, :order => "created_at DESC")
    @featured_company_details = CompanyDetail.featureds
    @company_detail = CompanyDetail.find_by_id(params[:company_detail_id])
    @company_details = CompanyDetail.approveds
  end 

  def company_hub
    @company_details = CompanyDetail
    @company_details = @company_details.where("lower(company_name) LIKE ?", "%#{params[:search_key].downcase}%") if params[:search_key].present?
    @company_details = @company_details.where(:company_type => params[:company_type]) unless params[:company_type] == "all" || params[:company_type].nil?
    @company_details = @company_details.where(:company_industry => params[:company_industry]) unless params[:company_industry] == "all" || params[:company_industry].nil?
    @company_details = @company_details.approveds.order('company_name ASC').paginate(:page => params[:page], :per_page => 10)
  end

  def career_info
  
  end

  def search_jobs
    key = params[:keyword].split(" ").join("+")
    position_level = "%22"+params[:position_level]+"%22"
    education = "%28"+params[:education]+"%29"
    job_type = params[:job_type]
    query = key 
    query += "+"+position_level unless params[:position_level] == "all"
    query += "+"+education unless params[:education] == "all"
    user_agent = URI.encode(request.env['HTTP_USER_AGENT'])
    user_ip = request.remote_ip
    start = params[:page].present? ? params[:page].to_i*10 - 10 : 0
    start = start.to_s
    url_path = "http://api.indeed.com/ads/apisearch?publisher=8086320755554674&q="+query+"&format=json&l=singapore&sort=&radius=&st=&jt="+job_type+"&start="+start+"&limit=&fromage=&filter=&co=sg&chnl=&userip="+user_ip+"&useragent="+user_agent+"&v=2"
    request_result = Net::HTTP.get(URI.parse(url_path))
    json = ActiveSupport::JSON.decode(request_result)
    @results = json["results"]
    @total_results = json["totalResults"]
    @total_pages = @total_results/10+1
    @page_number = json["pageNumber"]+1
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