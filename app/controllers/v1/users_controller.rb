class V1::UsersController < ::ApplicationController
  # GET /v1/users/current(.:format) v1/users#current {:format=>:json}
  def current
    render(json: current_user.attributes)
  end
end
