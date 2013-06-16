class ApplicationController < ActionController::Base
  include Injection::Controller::Application

  layout :load_layout

  protect_from_forgery

  def load_layout
    return "application" unless current_user
    if current_user.is_student?
      "application_student"
    elsif current_user.is_alumni?
      "application_student"
    elsif current_user.is_employer?
      "application_employer"
    elsif current_user.is_admin?
      "application_admin"
   	else
      "application"
    end
  end

end
