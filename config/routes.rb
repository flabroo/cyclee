Rails.application.routes.draw do
  get 'reports/create'
  devise_for :users
  root to: "lanes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :lanes do
    resources :reviews
    collection do
      get :sample
    end
  end

  resources :users do
    resources :parking_histories
  end

  resources :parking_locations do
    resources :reports, only: %i[show create]
  end
end
