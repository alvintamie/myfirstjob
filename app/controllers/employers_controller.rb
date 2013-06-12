class EmployersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :show, :update, :change_password]
  before_filter :allow_non_login_only, :only => [:new, :create]

  def new
    @user = User.new
    @user.build_employer
  end

  def create
    @user = User.new(params[:user])
    @user.role = "employer"
    @user.activated = false
    if @user.save
      SendActivationLinkWorker.perform_async(@user.id)
      redirect_to confirmation_page_users_path
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    params[:user].delete(:email)
    if @user.update_attributes(params[:user])
      flash[:success] = "You have successfully updated your profile"
      redirect_to profile_path
    else
      render :edit
    end  
  end



end