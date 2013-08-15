class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :show, :update, :change_password]
  before_filter :allow_non_login_only, :only => [:new, :create, :forget_password, :retrieve_password, :activate]

  def new
    @user = User.new
    @user.build_student
    @form_type = "form_student"
  end

  def create
    @user = User.new(params[:user])
    @form_type = params[:student].present? ? "form_student" : "form_alumni"
    @user.role = params[:student].present? ? "student" : "alumni"
    @user.activated = false
    if @user.save
      SendActivationLinkWorker.perform_async(@user.id)
      redirect_to confirmation_page_users_path
    else
      render :new
    end
  end

  def edit
    @form_type = current_user.role == "student" ? "form_student" : "form_alumni"
    @user = current_user
  end

  def update
    @user = current_user
    params[:user].delete(:email)
    if @user.update_attributes(params[:user])
      flash[:success] = "You have successfully updated your profile."
      redirect_to profile_path
    else
      render :edit
    end  
  end

  def change_password
    @user = current_user
  end

  def post_forget_password
    if params[:email].blank?
      flash.now[:danger] = "You need to enter your email address."
      return render :forget_password
    end
    
    user = User.find_by_email(params[:email])
    if user.nil?
      flash.now[:danger] = "The email doesn't exist in our database."
      return render :forget_password
    end
    
    #MailUser.forget_password(user.id).deliver #to be enqueued
    #Resque.enqueue(ForgetPasswordWorker, user.id)
    ForgetPasswordWorker.perform_async(user.id)
    flash[:success] = "We have sent an email to your email address. Please check your email account."
    params.delete(:email)
    redirect_to login_url
  end

  def forget_password
  end

  def activate
    user = User.find_by_id(params[:id])
    is_matched = Digest::SHA1.hexdigest("#{params[:id]}#{params[:key]}#{ACTIVATION_KEY}") == params[:digest]
    
    if user.nil? || !is_matched
      flash[:danger] = "You entered an invalid link."
      return redirect_to root_url
    end
    
    user.update_attribute("activated", true)
    flash[:success] = "You have successfully activated your account."
    return redirect_to root_url
  end

  def confirmation_page
  end

  def retrieve_password    
    if is_expired = (Time.at(params[:expired].to_i) < Time.now) rescue true
      flash[:danger] = "You link has expired. Register your email address again to receive new link."
      return redirect_to forget_password_profile_url
    elsif (user = User.find_by_id(params[:id])).nil?
      flash[:danger] = "You entered an invalid link. Register your email address again to receive new link."
      return redirect_to forget_password_profile_url
    elsif !(is_matched = Digest::SHA1.hexdigest("#{params[:expired]}#{user.password_recoverable}") == params[:digest])
      flash[:danger] = "You entered an invalid link. You might have already activated this link once. Register your email address again to receive new link."
      return redirect_to forget_password_profile_url
    end
    
    user.password = user.password_confirmation = Digest::SHA1.hexdigest(params[:digest]).first(8)
    user.password_recoverable = SecureRandom.uuid.gsub("-", "")
    user.save
    
    session[:user_id] = user.id
    flash[:success] = "You have successfully activated your password to #{user.password}. Perhaps, you might want to change your password to an easier one to remember right now."
    return redirect_to edit_profile_url
  end

end