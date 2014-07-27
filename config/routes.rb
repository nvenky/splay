Betfair::Application.routes.draw do
  resources :simulations, only: [:new] do
    collection do
      post :run
    end
  end
  resources :market_filters

  match 'jobs/run', to: 'jobs#run', via: :get
  match 'jobs/load_event_types', to: 'jobs#load_event_types', via: :get
  match 'jobs/load_markets', to: 'jobs#load_markets', via: :get
  match 'jobs/update_markets', to: 'jobs#update_markets', via: :get
  match 'home', to: 'home#new', via: :get

  root 'simulations#new'

  #Authentication
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
end
