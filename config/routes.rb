Rails.application.routes.draw do
  resources :products
  # Kamal health check route

  get :up, to: 'home#up'
  # Routes For Login /Signup
  devise_for :users, only: [:sessions], path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }
  devise_scope :user do
    get 'register', to: 'devise/registrations#new', as: 'new_user_registration'
    post 'register', to: 'devise/registrations#create', as: 'registration'
    get 'users/edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users/update', to: 'devise/registrations#update', as: 'update_user_registration'
    get 'forgot_password', to: 'devise/passwords#new', as: 'new_user_password'
    post 'reset_password', to: 'devise/passwords#create', as: 'user_password'
    get 'users/password/edit', to: 'devise/passwords#edit', as: 'edit_user_password'
    put 'users/update_password', to: 'devise/passwords#update', as: 'update_user_password'
  end

  # Application routes
  root "products#index"
  post "checkout/create", to: "checkout#create"

  # Routes for Apis
  namespace :api do
    namespace :v1, defaults: { format: :json } do

      mount_devise_token_auth_for "User", at: "/users", controllers: {
        sessions: "api/v1/sessions",
        passwords: "api/v1/passwords",
        registration: "api/v1/registrations"
      }
      devise_scope :api_v1_user do
        scope :users do
          post 'login', to: 'sessions#create', as: :user_login
          post 'register', to: 'registrations#create', as: :user_register
          delete 'logout', to: 'sessions#destroy', as: :user_destroy_session
          post 'forgot_password', to: 'passwords#create', as: :user_create_password
          put 'reset_password', to: 'passwords#update', as: :user_reset_password
          put 'update_password', to: 'users#update_password', as: :user_update_password
          put 'update', to: 'users#update', as: :user_update
          get 'profile', to: 'users#profile'
          get 'validate_token', to: 'token_validations#validate_token', as: :validate_token
        end
      end
    end
  end
end
