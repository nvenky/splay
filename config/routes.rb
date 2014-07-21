Betfair::Application.routes.draw do
  resources :simulations, only: [:new] do
    collection do
      post :run
    end
  end

  match 'jobs/run', to: 'jobs#run', via: :get
  match 'home', to: 'home#new', via: :get

  root 'simulations#new'

  #Authentication
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
end
