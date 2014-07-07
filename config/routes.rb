Betfair::Application.routes.draw do
  resources :simulations, only: [:new] do
    collection do
      post :run
    end
  end
  match 'jobs/load_event_types', to: 'jobs#load_event_types', via: :get
  match 'jobs/load_markets', to: 'jobs#load_markets', via: :get
  match 'jobs/update_markets', to: 'jobs#update_markets', via: :get
end
