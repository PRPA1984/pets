class V1::UserController < ::ApplicationController

  def password
    if current_user.present?
      if current_user.password == params[:currentPassword]
        current_user.update(password: params[:newPasssword])
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
    else
      error = {
        messages: [
          { path: "/v1/user/password",
            message: 'No existe el usuario'
          }
        ]
      }

      render(json: error, status: 401)
    end
    end
  end
end
