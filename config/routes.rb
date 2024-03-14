Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  resources :schedules, only: %i[new create index show]
  resources :emergencies, only: %i[new create show]

  post '/update_schedule_location/:id', to: 'schedules#update_location'
  patch '/emergencies/:id/finish', to: 'emergencies#finish', as: :finish_emergency
  get '/adm', to: 'adms#inicial', as: :home_adm
end
