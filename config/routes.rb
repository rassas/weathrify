Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "weathers#index"

  resources :registrations, path: :users, path_names: { new: :sign_up }, only: [ :new, :create ]
  resource :session, path: :users, path_names: { new: :sign_in }, only: [ :new, :destroy ]
  resource :session, path: "users/sign_in", only: [ :create ]

  resources :cities, only: [] do
    collection do
      post :toggle_favorite
    end
  end

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resource :session, path: "users/sign_in", only: [ :create ]
        resource :session, path: :users, only: [ :destroy ]
        resources :registrations, path: :users, only: [ :create ]
      end
    end
  end
end
