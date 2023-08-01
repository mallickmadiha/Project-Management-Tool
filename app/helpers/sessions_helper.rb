# frozen_string_literal: true

# app/helpers/sessions_helper.rb
module SessionsHelper
  def process_user(user)
    if user
      process_existing_user(user)
    else
      user = find_or_create_user

      if user.valid?
        process_new_user(user)
      else
        redirect_to_root_path_with_error_flash(user.errors)
      end
    end
  end

  def find_user_by_email(email)
    User.find_by(email:)
  end

  def valid_authentication?(user, password)
    user&.authenticate(password)
  end

  def user_session_set(user)
    session[:id] = user.id
    cookies.signed[:user_id] = user.id
  end

  def redirect_to_projects_path_with_success_flash
    redirect_to projects_path, flash: { success: 'User Logged In Successfully' }
  end

  def redirect_to_root_path_with_error_flash(message)
    redirect_to root_path, flash: { error: message.full_messages.join(', ') }
  end

  def find_or_create_user
    user = User.find_by_email(request.env['omniauth.auth'][:info][:email])
    user ||= create_user

    user
  end

  def process_existing_user(user)
    user_session_omni(user)
    redirect_to_projects_path_with_success_flash
  end

  def process_new_user(user)
    user_session_omni(user)
    redirect_to_projects_path_with_success_flash
  end

  def user_session_omni(user)
    session[:id] = user.id
    cookies.signed[:user_id] = user.id
    set_access_token_omni
  end

  def create_user
    User.create(uid: omniauth_uid,
                provider: omniauth_provider, username: request.env['omniauth.auth'][:info][:first_name],
                email: request.env['omniauth.auth'][:info][:email],
                password: generate_password_digest)
  end

  def omniauth_uid
    request.env['omniauth.auth'][:uid]
  end

  def omniauth_provider
    request.env['omniauth.auth'][:provider]
  end

  def generate_password_digest
    SecureRandom.hex(15)
  end

  def set_access_token_omni
    access_token = request.env['omniauth.auth'][:credentials][:token]
    session[:access_token] = access_token
    revoke_token(access_token) if access_token.present?
  end

  def revoke_token(token)
    response = HTTParty.post('https://accounts.google.com/o/oauth2/revoke',
                             query: { token: },
                             headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
    return unless response.code == 200
  end
end
