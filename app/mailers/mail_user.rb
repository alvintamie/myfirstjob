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
end
