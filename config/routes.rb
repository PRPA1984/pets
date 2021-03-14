Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :v1, defaults: { format: :json } do
    # resources :user, only: [] do
    #   collection do
    #     post :password # Cambiar el password del usuario actual.
    #   end
    # end

    resources :user, only: [:index, :create] do
      collection do
        post :signin
        get :signout
        get :current
        post :password # Cambiar el password del usuario actual.
      end
      member do
        post :disable
        post :enable
        post :grant
        post :revoke
      end
    end
  end
end
