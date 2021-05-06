class V1::UsersController < ApplicationController

  before_action :check_token, only: [:index, :signout, :grant]

  def check_token
    return if current_user.present?

    render(json: format_error(request.path, 'No se quien sos'), status: 401)
  end

  def index
    if current_user.admin?
      # render(json: User.all.map { |user| user.json }, status: 200)
      render(json: User.all.map(&:json), status: 200)
    else
      render(json: format_error('/users', 'No sos admin'), status: 401)
    end
  end

  def signout
    if current_user.remove_token
      render(status: 200)
    else
      render(json: format_error('/users/signout', current_user.errors.full_messages), status: 401)
    end
  end

  def grant
    if current_user.admin?
      # TODO: Validar que los roles existan
      params["permissions"].each { |perm| current_user.add_role(perm) }
    else
      render(json: format_error(request.path, 'No sos admin'), status: 401)
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render(json: { token: user.token }, status: 200)
    else
      msg = { message: [
        {
          path: '/v1/users',
          message: user.errors.full_messages
        }]
      }
      render(json: msg, status: 400)
    end
  end

  def signin
    path = '/v1/users/signin'

    user = User.enabled.find_by(login: user_params[:login])

    msg, status = if user.present? && user.valid_password?(user_params[:password])
                    [{ token: user.token }, 200]
                  else
                    error = user.blank? ? 'Vieja no existe ese' : 'Vieja es cualquiera el password'

                    [format_error(path, error), 400]
                  end

    render(json: msg, status: status)
  end

  def format_error(path, message)
    { message: [{ path: path, message: message }] }
  end

  def header_token
    request.headers["Authorization"].split(" ").last
  end

  def current_user
    @current_user ||= User.find_by(token: header_token)
  end

  def user_params
    params.require(:user).permit(:name, :login, :password)
  end
end
