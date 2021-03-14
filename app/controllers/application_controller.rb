class ApplicationController < ActionController::API

  before_action :verify_current_user_token

  rescue_from StandardError do |exception|
    render(status: 500, json: { error: exception.message })
  end

  private

  def verify_current_user_token
    return true if current_user.present?

    render(status: 401,
           json: {
             messages: [
               { path: "path",
                 message: 'No existe el usuario'
               }
             ]
           })
  end

  def current_user
    User.find_by(token: authorization_token)
  end

  def authorization_token
    request.headers["Authorization"].split(" ").last
  end
end
