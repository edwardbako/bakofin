Rails.application.routes.draw do

  resources :quotes, only: [:index, :show]
  resources :ticks, only: [:index, :create]

  root to: 'welcome#index'
end
