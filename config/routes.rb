Rails.application.routes.draw do
  get 'stocks/show'
  get 'stocks/edit'
  get 'stocks/update'
  devise_for :users

  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
  get '/emergencies/get_routes', to: 'emergencies#obtain_routes', as: 'get_routes'
  get '/emergencies_obtain_markers', to: 'emergencies#obtain_markers'

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  resources :schedules, only: %i[new create index show]
  resources :emergencies, only: %i[new create show]
  resources :workers
  resources :stocks, only: %i[new create show edit update ]

  post '/update_schedule_location_from_schedules_show_view/:id', to: 'schedules#update_location_from_schedules_show_view'
  post '/update_schedule_location_from_emergencies_show_view/:id', to: 'schedules#update_location_from_emergencies_show_view'
  patch '/emergencies/:id/finish', to: 'emergencies#finish', as: :finish_emergency
  get '/adm', to: 'adms#inicial', as: :home_adm
end
