class MailUser < ActionMailer::Base
  default from: "alvin.loh@2359media.com"

  def forget_password user, expired, digest, new_password
    @user = user
    @expired = expired
    @digest = digest
    @new_password = new_password
    mail to: @user.email
  end


  def send_activation_link user, key, digest
    @user = user
    @key = key
    @digest = digest
    mail to: @user.email
  end

  def send_company_detail_rejection_message user, message
    @user = user
    @message = message
    mail to: @user.email
  end

  def send_company_detail_approval_message user, company_detail
    @user = user
    @company_detail = company_detail
    mail to: @user.email
  end

  def send_job_rejection_message user, message
    @user = user
    @message = message
    mail to: @user.email
  end
end
