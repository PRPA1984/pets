class ApplicationController < ActionController::API

  rescue_from StandardError do |exception|
    render(status: 500, json: { error: exception.message })
  end

  def current_user
    User.find_by(token: authorization_token)
  end

  def authorization_token
    request.headers["Authorization"]
  end
end
