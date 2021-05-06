# POST /v1/user/password => Cambiar password

# POST /v1/users/:userId/disable
# POST /v1/users/:userId/enable Habilitar usuario
# GET  /v1/users => Listar usuarios
# POST /v1/users/signin => login
# GET  /v1/users/signout => logout
# POST /v1/users/:userId/grant => Otorgar permisos
# POST /v1/users => registrar usuario
# POST /v1/users/:userId/revoke => Revocar permisos
# GET  /v1/users/current => Get user

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :v1, default: { format: :json } do
    resources :user, only: [] do
      collection do
        post :password
      end
    end
    resources :users, only: [:index, :create] do
      member do
        post :disable # Deshabilitar usuario
        post :enable # Habilitar usuario
        post :grant
        post :revoke
      end
      collection do
        post :signin
        get :signout
        get :current
      end
    end
  end
end
