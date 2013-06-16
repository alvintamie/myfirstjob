class Student::UsersController < ApplicationController
  before_filter :authenticate_student_user!

  def edit
    @form_type = current_user.role == "student" ? "form_student" : "form_alumni"
    @user = current_user
  end

  def update
    @user = current_user
    params[:user].delete(:email)
    if @user.update_attributes(params[:user])
      flash[:success] = "You have successfully updated your profile"
      redirect_to edit_student_user_path
    else
      render :edit
    end 
  end

end