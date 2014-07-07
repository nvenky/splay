Betfair::Application.routes.draw do
  resources :simulations, only: [:new] do
    collection do
      post :run
    end
  end
end
