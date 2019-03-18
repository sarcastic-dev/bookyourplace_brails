class SessionsController < Devise::SessionsController

  require 'auth_token'

  # Disable CSRF protection
  # skip_before_action :verify_authenticity_token


  # Disable CSRF protection
  # protect_from_forgery
  # skip_before_action :verify_authenticity_token

  # Be sure to enable JSON.
  respond_to :json

  def create
    user = User.find_by_email(sign_in_params[:email])
    if user.verified == 1
      if user && user.valid_password?(sign_in_params[:password])
        token = AuthToken.issue_token({ user_id: user.id })
        render json: { message: 'Signed in successfully', auth_token: token }, status: :ok
      else
        render json: { errors: 'Email or password is invalid' }, status: :bad_request
      end
    else
      render json: { errors: 'Please verify your account.' }, status: :bad_request
    end
  end

end
