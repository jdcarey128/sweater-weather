Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 
      get '/forecast', to: 'forecast#show'
      get '/backgrounds', to: 'background_image#show'
      resources :users, only: [:create]
      resources :sessions, only: [:create]
      get '/munchies', to: 'munchies#show'
    end
  end
end
