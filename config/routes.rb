Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { sessions: 'sessions' }

  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
  get '/emergencies/get_routes', to: 'emergencies#obtain_routes', as: 'get_routes'
  get '/obtain_markers_only_current_emergency/:emergency_id', to: 'emergencies#obtain_markers_only_current_emergency'
  get '/emergencies_get_route/:emergency_id', to: 'emergencies#obtain_route_to_emergency_show', as: 'get_emergency_route'
  get '/emergencies_obtain_markers', to: 'emergencies#obtain_markers'
  get '/emergencies_show_obtain_markers/:emergency_id', to: 'emergencies#obtain_markers_to_emergencies_show'
  get '/schedules_obtain_markers/:schedule_id', to: 'schedules#obtain_markers'
  post '/update_location_from_schedules_show_view/:id', to: 'schedules#update_location_from_schedules_show_view'
  post '/update_location_from_emergencies_show_view/:id', to: 'schedules#update_location_from_emergencies_show_view'

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  resources :chats, only: :show do
    resources :posts, only: :create
  end

  resources :schedules, only: %i[new create index show]
  resources :emergencies, only: %i[new create show index] do
    resources :patients, only: %i[new create]
  end
  resources :workers
  resources :stocks, only: %i[new create show edit update]

  patch '/emergencies/:id/finish', to: 'emergencies#finish', as: :finish_emergency
  get '/adm', to: 'adms#inicial', as: :home_adm

  authenticate :user, ->(user) { user.admin? } do
    mount Blazer::Engine, at: "blazer"
  end
end
