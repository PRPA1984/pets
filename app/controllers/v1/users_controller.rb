class V1::UsersController < ::ApplicationController
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
end
