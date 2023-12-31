# rubocop:disable all

class UserMailer < ApplicationMailer
  default from: 'mallickmadiha9031@gmail.com'
  default from: 'example@gmail.com'

  def notification_email(creator_email, username, useremail, details_title, details_description)
    @username = username
    @useremail = useremail
    @details_title = details_title
    @details_description = details_description
    @creator_email = creator_email
    mail(to: useremail, subject: 'Message From ProjectManagementTool')
  end

  def notification_email_status(creator_email, username, useremail, details_title,
                                status, details_description)
    @username = username
    @useremail = useremail
    @details_title = details_title
    @details_description = details_description
    @status = status
    @creator_email = creator_email
    mail(to: useremail, subject: 'Message From ProjectManagementTool')
  end
end
