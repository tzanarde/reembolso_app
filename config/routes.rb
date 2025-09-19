Rails.application.routes.draw do
  root "pages#home"
  
  resources :expenses do
    member do
      patch :approve
      patch :decline
    end
  end

  get 'pages/home'
  get 'user_menu', to: 'pages#user_menu'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: "users/passwords"
  }

  get "up" => "rails/health#show", as: :rails_health_check
end
