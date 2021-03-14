class V1::UsersController < ::ApplicationController

  def current
    render(json: current_user.attributes)
  end
end
