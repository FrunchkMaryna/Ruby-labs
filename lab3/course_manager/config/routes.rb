Rails.application.routes.draw do
  resources :categories

  resources :courses do
    collection do
      get :active
    end
  end

  root "courses#index"
end
