Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  resources :schedules, only: %i[new create index]
  resources :emergencies, only: %i[new create show]
end
