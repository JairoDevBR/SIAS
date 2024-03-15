Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
  get '/emergencies/get_routes', to: 'emergencies#obtain_routes', as: 'get_routes'
  get '/emergencies_obtain_markers', to: 'emergencies#obtain_markers'
  post '/update_location_from_schedules_show_view/:id', to: 'schedules#update_location_from_schedules_show_view'
  post '/update_location_from_emergencies_show_view/:id', to: 'schedules#update_location_from_emergencies_show_view'

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  resources :schedules, only: %i[new create index show]
  resources :emergencies, only: %i[new create show]
  resources :workers

  patch '/emergencies/:id/finish', to: 'emergencies#finish', as: :finish_emergency
  get '/adm', to: 'adms#inicial', as: :home_adm
end
