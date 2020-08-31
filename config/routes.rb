Rails.application.routes.draw do
  root 'lists#index'

  resources :cards do
    member do
      patch :move
    end
  end

  resources :lists do
    member do
      patch :move
    end
  end
end
