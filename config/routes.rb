Rails.application.routes.draw do
  root "pages#home"
  
  get 'pages/home'
  get 'user_menu', to: 'pages#user_menu'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: "users/passwords"
  }

  get "up" => "rails/health#show", as: :rails_health_check
end
