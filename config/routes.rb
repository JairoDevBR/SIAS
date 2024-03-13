Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  resources :schedules, only: %i[new create index show]
  resources :emergencies, only: %i[new create show]

  post '/update_schedule_location_from_schedules_show_view/:id', to: 'schedules#update_location_from_schedules_show_view'
  post '/update_schedule_location_from_emergencies_show_view/:id', to: 'schedules#update_location_from_emergencies_show_view'
end
