class SessionsController < ApplicationController
  #before_filter :allow_non_login_only, :except => :destroy
  
  def new
    
  end
  
  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      if !user.activated
        @warning = "You haven't activated your account. Please check your email to activate your account now."
      elsif user.locked
        @warning = "Your account has been locked by the administrator, please contact the us for more detail."
      else      
        session[:user_id] = user.id
        params[:remember_me] ? cookies.permanent[:auth_token] = user.auth_token : cookies[:auth_token] = user.auth_token
        @success = "You have successfully logged in"
      end
    else
      @warning = "Email or Password is invalid"
    end

    if @warning
      flash.now[:warning] = @warning
      render :new
    elsif @success
      if user.is_student? || user.is_alumni?
        redirect_to student_root_path
      elsif user.is_employer?
        redirect_to employer_root_path
      else
        redirect_to root_path
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    cookies.delete(:auth_token)
    flash[:success] = "You have successfully logged out"
    redirect_to root_url
  end
end
