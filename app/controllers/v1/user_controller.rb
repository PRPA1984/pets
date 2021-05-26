class V1::UserController < ApplicationController

  before_action :check_token, only: [:signout, :password]

  def signin
    user = User.enabled.find_by(login: user_params[:login])

    if user.present? && user.valid_password?(user_params[:password])
      render(json: { token: user.generate_token! }, status: 200)
    else
      error = user.blank? ? 'Vieja no existe ese' : 'Vieja es cualquiera el password'
      render(json: format_error(request.path, error), status: 401)
    end
  end

  def signout
    if current_user.remove_token(header_token)
      render(status: 200)
    else
      render(json: format_error(request.path, current_user.errors.full_messages), status: 401)
    end
  end

  def password
    if current_user.valid_password?(params["currentPassword"])
      if current_user.update(password: params["newPassword"])
        render(status: 200)
      else
        render(json: format_error(request.path, current_user.errors.full_messages), status: 401)
      end
    else
      render(json: format_error(request.path, 'El currentPassword es cualquiera'), status: 401)
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :password)
  end
end
