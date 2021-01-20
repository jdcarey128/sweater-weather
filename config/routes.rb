Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 
      get '/forecast', to: 'forecast#show'
      get '/backgrounds', to: 'background_image#show'
      post '/road_trip', to: 'road_trips#create'
      resources :users, only: [:create]
      resources :sessions, only: [:create]
      get '/munchies', to: 'munchies#show'
    end
  end
end
