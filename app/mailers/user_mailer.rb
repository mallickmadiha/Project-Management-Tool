# frozen_string_literal: true

# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: 'mallickmadiha9031@gmail.com'

  def notification_email(creator_email, username, useremail, details_id)
    @username = username
    @useremail = useremail
    @details_id = details_id
    mail(to: creator_email, subject: 'Message From ProjectManagementTool')
  end

  def notification_email_status(creator_email, username, useremail, details_id, status)
    @username = username
    @useremail = useremail
    @details_id = details_id
    @status = status
    mail(to: creator_email, subject: 'Message From ProjectManagementTool')
  end
end
