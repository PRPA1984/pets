class V1::UsersController < ApplicationController
  before_action :check_token,
    only: [
      :index,
      :grant,
      :current,
      :revoke,
      :enable,
      :disable
    ]

  before_action :verify_current_user_admin,
    only: [
      :index,
      :grant,
      :revoke,
      :enable,
      :disable
    ]

  before_action :verify_selected_client,
    only: [
      :grant,
      :revoke,
      :enable,
      :disable
    ]

  def index
    render(json: User.all.map(&:json), status: 200)
  end

  def grant
    # TODO: Validar que los roles existan
    params["permissions"].each { |perm| selected_user.add_role(perm) }
    render(status: 200)
  end

  def revoke
    params["permissions"].each { |perm| selected_user.remove_role(perm) }
    render(status: 200)
  end

  def enabled
    selected_user.update(enable: true)
    render(status: 200)
  end

  def disable
    selected_user.update(enable: false)
    render(status: 200)
  end

  def current
    json = current_user.json
    json.delete(:enabled)

    render(json: json, status: 200)
  end

  def user_params
    params.require(:user).permit(:name, :login, :password)
  end
end
