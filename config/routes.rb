Rails.application.routes.draw do
  root 'main#index'
  
  post '/lookup', to: "main#lookup"
  get '/show_historical_whois', to: "main#show_historical_whois"
  
  # post '/lookup', to: 'main#lookup'
  # get '/lookup', to: 'main#index'
  # resources :dns_lookup, only: [:index, :lookup]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
