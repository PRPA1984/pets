class V1::UserController < ::ApplicationController

  skip_before_action :create, :signin

  def password
    if current_user.password == params[:currentPassword]
      current_user.update(password: params[:newPassword])
      render(status: 200)
    else
      error = {
        messages: [
          { path: "/v1/user/password",
            message: 'Current password erroneo'
          }
        ]
      }

      render(json: error, status: 401)
    end
  end

  def index
    render(json: User.all, status: 200)
  end

  def create
    user = User.new(name: params[:name], login: params[:login], password: params[:password])

    if user.save
      render(json: { token: user.token }, status: 200)
    else
      error = { messages: [{ path: '/v1/users/', message: user.errors.full_messages }] }
      render(json: error, status: 401)
    end
  end

  def signin
    user = User.find_by(login: user_params[:login], password: user_params[:password])

    if user.present?
      render(json: { token: user.token }, status: 200)
    else
      error = { messages: [{ path: '/v1/users/signin', message: 'No existe el usuario' }] }
      render(json: error, status: 401)
    end
  end

  def signout
    render(json: { status: 200 })
  end

  def disable
    if current_user.admin?
      user = User.find_by(id: params[:id])

      if user.present?
        user.update(enabled: false)
        render(status: 200)
      else
        error = { messages: [{ path: '/v1/users/:id/disable',
                               message: 'No existe el usuario' }] }
        render(json: error, status: 401)
      end
    else
      error = { messages: [{ path: '/v1/users/:id/disable',
                             message: 'No sos Admin' }] }
      render(json: error, status: 401)
    end
  end

  def enable
    if current_user.admin?
      user = User.find_by(id: params[:id])

      if user.present?
        user.update(enabled: true)
        render(status: 200)
      else
        error = { messages: [{ path: '/v1/users/:id/enable',
                               message: 'No existe el usuario' }] }
        render(json: error, status: 401)
      end
    else
      error = { messages: [{ path: '/v1/users/:id/enable',
                             message: 'No sos Admin' }] }
      render(json: error, status: 401)
    end
  end

  def grant
    user = User.find_by(id: params[:id])

    if user.present?
      user.add_roles(params[:permissions])
    else
      error = {
        messages: [
          { path: "/v1/users/#{params[:id]}/grant",
            message: 'No existe el usuario'
          }
        ]
      }

      render(json: error, status: 401)
    end
  end

  def revoke
    user = User.find_by(id: params[:id])

    if user.present?
      # TODO: [PEDIR] Ver como viene la request por que no se, como viene.
      user.remove_roles(params[:permissions])
      render(status: 200)
    else
      error = {
        messages: [
          { path: "/v1/users/#{params[:id]}/revoke",
            message: 'No existe el usuario'
          }
        ]
      }

      render(json: error, status: 401)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :login, :password)
  end
end
