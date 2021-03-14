class ApplicationController < ActionController::API

  def current_user
    User.find_by(token: authorization_token)
  end

  def authorization_token
    request.headers["Authorization"]
  end
end
