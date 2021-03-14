class V1::UsersController < ::ApplicationController
  # GET /v1/users(.:format) v1/users#index {:format=>:json}
  # curl -H "Authorization: 1234" -H "Content-Type: application/json" 127.0.0.1:3000/v1/users -v
  def index
    render(json: User.all, status: 200)
  end

  # POST /v1/users(.:format) v1/users#create {:format=>:json}
  def create
    user = User.build(name: params[:name], login: params[:login], password: params[:password])

    if user.save
      render(json: { token: user.token }, status: 200)
    else
      error = { messages: [{ path: '/v1/users/', message: user.errors.full_messages }] }
      render(json: error, status: 401)
    end
  end

  # POST /v1/users/signin(.:format) v1/users#signin {:format=>:json}
  # curl -H "Authorization: 1234" -H "Content-Type: application/json" -d '{"login": "admin", "password": "12345678"}' 127.0.0.1:3000/v1/users/signin -v
  def signin
    user = User.find_by(login: user_params[:login], password: user_params[:password])

    if user.present?
      render(json: { token: user.token }, status: 200)
    else
      error = { messages: [{ path: '/v1/users/signin', message: 'No existe el usuario' }] }
      render(json: error, status: 401)
    end
  end

  # GET /v1/users/signout(.:format) v1/users#signout {:format=>:json}
  def signout
    render(json: { status: 200 })
  end

  # POST /v1/users/:id/disable(.:format) v1/users#disable {:format=>:json}
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

  # POST /v1/users/:id/enable(.:format) v1/users#enable {:format=>:json}
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

  # POST /v1/users/:id/grant(.:format) v1/users#grant {:format=>:json}
  # curl -H "Authorization: 1234" -H "Content-Type: application/json" -d '{"permissions": ["admin", "user"]}' 127.0.0.1:3000/v1/users/1/grant -v
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

  # POST /v1/users/:id/revoke(.:format) v1/users#revoke {:format=>:json}
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

  # GET /v1/users/current(.:format) v1/users#current {:format=>:json}
  def current
    if current_user.present?
      render(json: current_user.attributes)
    else
      error = {
        messages: [
          { path: "/v1/users/current",
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
